trigger LeadConvertValidation on Lead (before Update) {
    if(Trigger.isUpdate){
        for(Lead l:Trigger.new){
            if(l.LastName.containsIgnoreCase('DoNotConvert')){
                l.addError('Lead is not eligible for conversion');
            }
        }
    }
}