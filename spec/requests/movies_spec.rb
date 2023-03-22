require 'rails_helper'

RSpec.describe '/movies', type: :request do

  describe 'GET /index' do

    it 'renders a successful respons' do
      get root_url

      expect(response).to be_successful
      expect(response).to render_template(:index)
      expect(response.body).to include("id='search-input'")
      expect(response.body).to include("id='search-submit'")
    end

  end

  describe 'GET /search' do

    let(:first_page_url) { Rails.configuration.tmdb.search_url + '?' + {api_key: Rails.configuration.tmdb.api_key, page: 1, query: 'Nemo'}.to_query }
    let(:first_page_result) { File.read(Rails.root.join('spec', 'support', 'fixtures', 'result_page1.json')) }
    let (:n_page_url) { Rails.configuration.tmdb.search_url + '?' + {api_key: Rails.configuration.tmdb.api_key, page: 3, query: 'Nemo'}.to_query }
    let (:n_page_result) { File.read(Rails.root.join('spec', 'support', 'fixtures', 'result_pagen.json')) }

    context 'without cached results' do

      it 'gets results from API and save to database' do
        stub_request(:get, first_page_url).
          to_return(status: 200, body: first_page_result)

        expect {
          get movies_search_url({query: 'Nemo'})
        }.to change(Query, :count).by(1)
        expect(Query.first.hit_count).to eq(0)
        expect(response).to be_successful
      end

      it 'renders the results' do
        stub_request(:get, first_page_url).
          to_return(status: 200, body: first_page_result)

        get movies_search_url({query: 'Nemo'})
        expect(response).to render_template(:_collection)
        expect(response.body).to include("Total results: 94")
        expect(response.body).to include("Result from API")
      end

      it 'gets results for a certian page from API and save to database' do
        stub_request(:get, n_page_url).
          to_return(status: 200, body: n_page_result)

        expect {
          get movies_search_url({query: 'Nemo', page: 3})
        }.to change(Query, :count).by(1)
        expect(response).to be_successful
      end

      it 'renders a certain page of results' do
        stub_request(:get, n_page_url).
          to_return(status: 200, body: n_page_result)

        get movies_search_url({query: 'Nemo', page: 3})
        expect(response).to render_template(:_collection)
        expect(response.body).to include("Total results: 94")
        expect(response.body).to include("Result from API")
      end

      it 'does not increase the hit count' do
        stub_request(:get, first_page_url).
          to_return(status: 200, body: first_page_result)

        get movies_search_url({query: 'Nemo'})
        expect(Query.first.hit_count).to eq(0)
      end

    end

    context 'with cached result' do

      it 'gets results from database' do
        query = Query.create!( query: 'Nemo', total_results: 94, total_pages: 5, page: 1)
        stub_request(:get, first_page_url).
          to_return(status: 200, body: first_page_result)

        expect {
          get movies_search_url({query: 'Nemo'})
        }.to change(Query, :count).by(0)
        expect(response).to be_successful
      end

      it 'renders the results' do
        Query.create!( query: 'Nemo', total_results: 94, total_pages: 5, page: 1)
        stub_request(:get, first_page_url).
          to_return(status: 200, body: first_page_result)

        get movies_search_url({query: 'Nemo'})
        expect(response).to render_template(:_collection)
        expect(response.body).to include("Total results: 94")
        expect(response.body).to include("Results from cache. Hit count: 1")
      end

      it 'gets results for a certain page from database' do
        query = Query.create!( query: 'Nemo', total_results: 94, total_pages: 5, page: 3)
        stub_request(:get, n_page_url).
          to_return(status: 200, body: n_page_result)

        expect {
          get movies_search_url({query: 'Nemo', page: 3})
        }.to change(Query, :count).by(0)
        expect(response).to be_successful
      end

      it 'renders a certain page of results' do
        Query.create!( query: 'Nemo', total_results: 94, total_pages: 5, page: 3)
        stub_request(:get, n_page_url).
          to_return(status: 200, body: n_page_result)

        get movies_search_url({query: 'Nemo', page: 3})
        expect(response).to render_template(:_collection)
        expect(response.body).to include("Total results: 94")
        expect(response.body).to include("Results from cache. Hit count: 1")
      end

      it 'increases the hit count' do
        query = Query.create!( query: 'Nemo', total_results: 94, total_pages: 5, page: 3)
        stub_request(:get, n_page_url).
          to_return(status: 200, body: n_page_result)

        get movies_search_url({query: 'Nemo', page: 3})
        expect(query.reload.hit_count).to eq(1)
      end

    end

    context 'with invalid API config' do

      it 'does not save query to database' do
        stub_request(:get, first_page_url).
          to_return(status: 401)

        expect {
          get movies_search_url({query: 'Nemo', page: 1})
        }.to change(Query, :count).by(0)
      end

      it 'renders alert message' do
        stub_request(:get, first_page_url).
          to_return(status: 401)

        get movies_search_url({query: 'Nemo', page: 1})
        expect(response.body).to include("...we&#39;ve had a problem here.")
      end

    end

  end

end
