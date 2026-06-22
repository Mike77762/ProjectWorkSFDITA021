@RestResource(urlMapping='/BankDetails/*')
global without sharing class BankInfoRestResource {

    @HttpGet
    global static Map<String, String> getBankInfo() {
        Map<String, String> bankInfo = new Map<String, String>();
        bankInfo.put('Name', 'SFDITA Bank');
        bankInfo.put('Address', 'Via Roma 1');
        bankInfo.put('Swift', 'SFDITAIT');
        bankInfo.put('Phone', '+39 011 0000000');
        bankInfo.put('Email', 'info@sfditabank.it');
        return bankInfo;
    }
}