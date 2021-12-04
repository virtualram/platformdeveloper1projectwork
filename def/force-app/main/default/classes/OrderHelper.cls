public class OrderHelper {


    public static void AfterUpdate(List<Order> newList, List<Order> oldList){
        Set<Id> orderIds = new Set<Id>();
        for ( Integer i=0; i<newList.size(); i++ ){
            if (newList[i].Status == Constants.ACTIVATED_ORDER_STATUS && oldList[i].Status != Constants.ACTIVATED_ORDER_STATUS){
                orderIds.add(newList[i].Id);
            }
        }
        RollUpOrderItems(orderIds);
    }

    public static void RollUpOrderItems(Set<Id> activatedOrderIds){
        
        Map<Id,Product2> productMap = new Map<Id,Product2>();
        Set<Id> productIds = new Set<Id>();
        
       
        for(OrderItem oi : [SELECT Id, Product2Id, Product2.Quantity_Ordered__c, Quantity FROM OrderItem
                            WHERE OrderId IN :activatedOrderIds]){
            productIds.add(oi.Product2Id);                         
        }
        
        
        productMap = new Map<Id, Product2>([SELECT Id, Quantity_Ordered__c FROM Product2 WHERE Id IN :productIds]);
        
        AggregateResult[] groupedResult = [SELECT Product2Id, SUM(Quantity) activatedQuantity FROM OrderItem
                                             WHERE Product2Id IN :productMap.keySet() GROUP BY Product2Id];
        
      
        for(AggregateResult ar : groupedResult){
            productMap.get((String)ar.get('Product2Id')).Quantity_Ordered__c = Integer.valueOf(ar.get('activatedQuantity'));
        }
        
       
        update productMap.values();
    }

}