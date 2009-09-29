// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
document.observe('dom:loaded', function(){
  $$('.sidebar>ul>li').invoke('observe','click', function(e){
   $$('.sidebar>ul>li>ul').without(e.element().down('ul')).invoke('hide');
   if(e.element().down('ul')){
     e.element().down('ul').toggle();
   }
  });
  $$('#customer_select input[type=text]').invoke('observe','keyup', function(e){
    var value = e.element().value.toLowerCase();
    var option_to_select = e.element().next('select').select('option').find(function(e){
      return e.innerHTML.toLowerCase().startsWith(value);
    });
    e.element().next('select').select('option').each(function(e){
      e.selected = false;
    })
    if(option_to_select){
      option_to_select.selected = true;
    }
  });
  $$('#customer_select input[type=text]').invoke('observe','keyup', function(e){
    var value = e.element().value.toLowerCase();
    var option_to_select = e.element().next('select').select('option').find(function(e){
      return e.innerHTML.toLowerCase().startsWith(value);
    });
    e.element().next('select').select('option').each(function(e){
      e.selected = false;
    })
    if(option_to_select){
      option_to_select.selected = true;
    }
  });
  $$('form#customer_select').invoke('observe','submit', function(e){
    e.stop();
    document.location = "/organisations/" + e.element().down('select').value + "/quotes/new" ;
  });
});