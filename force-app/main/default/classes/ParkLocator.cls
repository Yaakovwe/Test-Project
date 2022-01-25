public with sharing class ParkLocator {
    public static string[] country(string countryString) {
        ParkService.ParksImplPort service = new ParkService.ParksImplPort();
        return service.byCountry(countryString);
    }
}
