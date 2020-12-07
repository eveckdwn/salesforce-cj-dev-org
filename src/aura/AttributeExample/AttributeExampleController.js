({
    doClick : function(component, event, helper) {
        alert(component.isValid());

        //  get(String | object name)
        alert(component.getName());
        alert(component.get('v.whom'));
        
        //  set(String keyObject valueProvider)
        //  2parameters
        //  key - Attribute
        //  Value - That we wnated to be set in the attribute
        component.set('v.whom', "Test Value");
        var ageComp = component.find('testInput');
        alert(ageComp.get('v.value'));
        ageComp.set('v.value', 67);
    },
    doCreateMap : function(component, event, helper){
        var map = [];
        //  Key and Value
        for(var i = 0; i < 10; i++){
            map.push({
                key: i,
                value:'Test ' + i
            });
        }
        component.set('v.mapVar', map);
    }
})