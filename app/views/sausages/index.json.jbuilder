json.array!(@sausages) do |sausage|
  json.extract! sausage, 
  json.url sausage_url(sausage, format: :json)
end