// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
document.observe('dom:loaded', function(){
  $$('.sidebar>ul>li').invoke('observe','click', function(e){
    e.element().down('ul').toggle();
  });
});