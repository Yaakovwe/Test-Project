public with sharing class AnimalLocator {
	public static String getAnimalNameById(Integer id) {
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		String endpoint = 'https://th-apex-http-callout.herokuapp.com/animals/';
		request.setEndpoint(endpoint + id);
		request.setMethod('GET');
		HttpResponse response = http.send(request);
		// If the request is successful, parse the JSON response.
		String name  = '';
		if(response.getStatusCode() == 200) {
			// Deserialize the JSON string into collections of primitive data types.
			Map<String, Object> results = (Map<String, Object>) 
				JSON.deserializeUntyped(response.getBody());
			Map<String, Object> animal = (Map<String, Object>) 
				results.get('animal');
			name = (String) animal.get('name');
		}
		return name;
	}
}
