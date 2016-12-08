require 'swagger_helper'

describe 'Ownerships API' do

  path '/ownerships' do

    post 'Creates an ownership' do
      tags 'Ownerships'
      consumes 'application/json'
      parameter name: :ownership, in: :body, schema: {
        type: :object,
        properties: {
          owner_id: { type: :string },
          model_id: { type: :string},
          model_type: { type: :string}
        },
        required: [ 'owner_id', 'model_id', 'model_type']
      }

      response '201', 'ownership created' do
        let(:ownership) { { 
        	owner_id: 'foo', 
        	model_id: 'bar' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:ownership) { { title: 'foo' } }
        run_test!
      end
    end
  end

  path '/ownerships/{model_id}' do

    get 'Retrieves a model' do
      tags 'Ownerships'
      produces 'application/json'
      parameter name: :model_id, :in => :path, :type => :string

      response '200', 'ownership found' do
        schema type: :object,
          properties: {
            model_id: { type: :integer },
            owner_id: { type: :string },
            model_type: { type: :string }
          },
          required: [ 'model_id', 'owner_id', 'model_type' ]

        let(:id) { Ownership.create(title: 'foo', content: 'bar').id }
        run_test!
      end

      response '404', 'blog not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
