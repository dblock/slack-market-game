require 'spec_helper'

describe Api::Endpoints::SlackEndpoint do
  include Api::Test::EndpointTest

  context 'graph' do
    it 'parses a good payload', vcr: { cassette_name: 'msft' } do
      post '/api/graph', payload: {
        'actions': [{ 'name' => '1m', 'value' => 'MSFT- 1m' }],
        'channel': { 'id' => 'D1L424242', 'name' => 'directmessage' },
        'token': ENV['SLACK_VERIFICATION_TOKEN'],
        'original_message': {
          'ts': '1467321295.000010'
        }
      }.to_json.as_json
      expect(last_response.status).to eq 201
    end
    it 'returns an error with non-matching verification token', vcr: { cassette_name: 'msft' } do
      post '/api/graph', payload: {
        'actions': [{ 'name' => '1m', 'value' => 'MSFT- 1m' }],
        'channel': { 'id' => 'D1L424242', 'name' => 'directmessage' },
        'token': 'invalid-token',
        'original_message': {
          'ts': '1467321295.000010'
        }
      }.to_json.as_json
      expect(last_response.status).to eq 401
    end
  end
end
