/**
 * Created by eveck on 2020-12-17.
 */

public without sharing class CustomNotificationFromApex {

    public void notifyUsers(Set<String> recipientsIds, String targetId) {

        // Get the Id for our custom notification type
        CustomNotificationType notificationType =
        [SELECT Id, DeveloperName
        FROM CustomNotificationType
        WHERE DeveloperName='CustomNotificationType_Test'];

        // Create a new custom notification
        Messaging.CustomNotification notification = new Messaging.CustomNotification();

        // Set the contents for the notification
        notification.setTitle('Apex Custom Notification');
        notification.setBody('The notifications are coming from INSIDE the Apex!');

        // Set the notification type and target
        notification.setNotificationTypeId(notificationType.Id);
        notification.setTargetId(targetId);

        // Actually send the notification
        try {
            notification.send(recipientsIds);
        }
        catch (Exception e) {
            System.debug('Problem sending notification: ' + e.getMessage());
        }
    }
}