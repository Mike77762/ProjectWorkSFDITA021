trigger TaskTrigger on Task (after insert, after update, before delete) {
    
    if (Trigger.isAfter && Trigger.isInsert) {
        TaskTriggerHandler.handleAfterInsertUpdate(Trigger.new);
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) {
        TaskTriggerHandler.handleAfterInsertUpdate(Trigger.new);
    }
    
    if (Trigger.isBefore && Trigger.isDelete) {
        TaskTriggerHandler.handleBeforeDelete(Trigger.old);
    }
}