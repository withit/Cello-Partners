// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
document.observe('dom:loaded', function(){
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
    var org_id = e.element().down('select').value;
    if(org_id)
    {
      document.location = "/organisations/" + org_id + document.location.pathname;
    } else { 
      alert('You must select a customer');
    }
  });
  // $$('.sidebar').invoke('observe', 'mouseout',function(e){
  //   if(!e.findElement('li'))
  //   {
  //     return;
  //   }
  //   li = e.findElement('li')
  //   if(!$(e.toElement).descendantOf(li))
  //   {
  //     li.removeClassName('active');
  //   }
  //   if(li = e.findElement('li').up('li'))
  //   {
  //     if(!$(e.toElement).descendantOf(li))
  //     {
  //       li.removeClassName('active');
  //     }
  //   }
  // });
  // $$('.sidebar').invoke('observe', 'mouseover',function(e){
  //   if(!e.findElement('li'))
  //   {
  //     return;
  //   }
  //   e.findElement('li').addClassName('active');
  //   if(e.findElement('li').up('li'))
  //   {
  //     e.findElement('li').up('li').addClassName('active');
  //   }
  // });
  $$('#select_role_form').invoke('observe','submit', function(e){
    e.stop();
    document.location = '/roles/' + $F('select_role') + '/edit';
  });
  $$('#email_quote').invoke('observe','click', function(e){
    e.stop();
    $('email_row').show();
  });
  $$('#order_existing_address_id').invoke('observe', 'change', function(e){
    if($F("order_existing_address_id").blank())
    {
      $$("#address_fields input").invoke('enable');
    } else {
      $$("#address_fields input").invoke('disable');
    }
  });
});

document.observe('dom:loaded', function(){
  new ProtoFish('menu', '200', 'active', false, false, false);
});