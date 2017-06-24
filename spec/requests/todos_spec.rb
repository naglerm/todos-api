require 'rails_helper'
#require 'support/request_spec_helper' !!!not properly importing the json method
#which is instead defined below
def json##was trying and failing to bring this in by REQUIREing support/request_spec_helper
    JSON.parse(response.body)
end

RSpec.describe "Todos API", type: :request do
  #create todo owner
  let(:user) {create(:user)}
  #initialize test data
  let!(:todos){create_list(:todo, 10, created_by: user.id)}
  let(:todo_id) {todos.first.id}
  #create auth content
  let(:headers) {valid_headers}

  #test suite for 'GET /todos'
  describe 'GET /todos' do
    #make HTTP get request before each example
    before {get  '/todos', params: {}, headers: headers}

    it 'returns todos' do
      #json is a custom helper to parse json objects
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  #test suite for 'GET todos/:id'
  describe 'GET /todos/:id' do
    before {get "/todos/#{todo_id}", params: {}, headers: headers}

    context 'when the record exists' do
      it 'returns the todo' do
        expect(json).to_not be_empty
        expect(json['id']).to eq(todo_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:todo_id) {100}

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a not found message' do
        expect(response.body).to match(/Couldn't find Todo/)
      end
    end
  end

  #Test suite for POST /todos
  describe 'POST /todos' do
    #valid payload
    let(:valid_attributes) do
      {title: 'Learn Prism', created_by: user.id.to_s}.to_json
    end

    context 'when the request is valid' do
      before {post '/todos', params: valid_attributes, headers: headers}

      it 'creates a todo' do
        expect(json['title']).to eq('Learn Prism')
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when the request is invalid' do
      let(:valid_attributes) { { title: nil }.to_json }
      before {post '/todos', params: valid_attributes, headers: headers}

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns a validation failure message' do
        expect(response.body).to match(/Validation failed: Title can't be blank/)
      end
    end
  end

  #test suite for PUT /todos/:id
  describe 'PUT /todos/:id' do
    let(:valid_attributes) {{title: 'Shopping', created_by: user.id.to_s}.to_json}

    context 'when the record exists' do
      before{put "/todos/#{todo_id}", params: valid_attributes, headers: headers}

      it 'updates the record' do
        expect(response.body).to be_empty
      end

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end
  end

  #test suite for DELETE /todos/:id
  describe 'DELETE /todos/:id' do
    before {delete "/todos/#{todo_id}", params: {}, headers: headers}

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end
  end
end