public class SObjectFieldDescribe {
    @AuraEnabled
    public String label { get; set; }

    @AuraEnabled
    public String name { get; set; }

    // Constructor
    public SObjectFieldDescribe(String label, String name) {
        this.label = label;
        this.name = name;
    }
}