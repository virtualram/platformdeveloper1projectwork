/**
 * @File Name          : ChartHelper.cls
 * @Description        : 
 * @Author             : wbatista@moldsoft.com.br
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 10-31-2020
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    19/01/2020   wbatista@moldsoft.com.br     Initial Version
**/
public without sharing class ChartHelper {

    @AuraEnabled
    public static List<chartData> GetInventory(){ 
        List<chartData> cht = new List<chartData>();

        List<AggregateResult> aggrs = [select SUM(Quantity_Remaining__c) qtd, Family from Product2 where IsActive = true and Quantity_Remaining__c > 0 group by Family];
        for(AggregateResult aggr: aggrs){
            cht.add(new ChartData((String)aggr.get('Family'),(Decimal) aggr.get('qtd')));
        }

        return cht;
    }

    public class ChartData {
        public String name {get;set;}
        public Decimal val {get;set;}

        public ChartData(String name, Decimal val){
            this.name = name;
            this.val = val;
        }
    }

}