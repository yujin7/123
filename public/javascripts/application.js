// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function reload_with_new_param(param, value){
    var per_page_added = false;
    var url = window.location.href;
    var base_url = window.location.href.indexOf('?') > 0 ? window.location.href.split("?")[0] :  window.location.href
    var new_params = "";
    var params = window.location.href.indexOf('?') > 0 ? window.location.href.split("?")[1] : ""
    if(params != ""){
        var parts = params.indexOf('&') > 0 ? params.split("&") : new Array(params)
        for (var i = 0; i < parts.length; i++ )
        {
            if(!(param == 'per_page' && parts[i].split("=")[0] == 'page')){
                if( parts[i].split("=")[0] == param){
                    per_page_added = true
                    new_params = new_params + (new_params == 0 ? "?"+param+"="+value : "&"+param+"="+value)
                }else{
                    if(parts[i].split("=")[0] != param){
                        new_params = new_params + (new_params == 0 ? "?"+parts[i] : "&"+parts[i])
                    }
                }
            }
            

        }
        new_params = !per_page_added ? (new_params != 0 ? new_params+"&"+param+"="+value : "?"+param+"="+value ) : new_params
    }
    window.location.href = base_url + (new_params == 0 ? "?"+param+"="+value : new_params)
}


function update_guest_status(id, status){
    $.ajax({
        url: "/guests/"+id+"/update_status/",
        data: {
            status: status
        },
        type: 'put',
        success: function(data) {
            $('#status_'+id).html(data);
        }
    });
}



function update_payment_status(id, status){
    $.ajax({
        url: "/payments/"+id+"/update_status/",
        data: {
            status: status
        },
        type: 'put',
        success: function(data) {
            $('#status_'+id).html(data);
        }
    });
}
















function update_inventory_status(id, status){
    $.ajax({
        url: "/inventories/"+id+"/update_status/",
        data: {
            status: status
        },
        type: 'put',
        success: function(data) {
            $('#status_'+id).html(data);
        }
    });
}



function get_sub_categories(id){
    if(id != ''){
        $.ajax({
            url: "/categories/"+id+"/get_sub_categories",
            success: function(data) {
                $('#service_sub_category_id').html(data);
            }
        });
    }
    else{
        $('#service_sub_category_id').empty();
    }
}

function get_service_names(id){
    $.ajax({
        url: "/packages/"+id+"/update_service_names/"
    });


}

function get_sub_categorie_products(id){
    if(id != ''){
        $.ajax({
            url: "/products/"+id+"/update_sub_categorie_products/"
        });
    }else{
        $('#sub_categories').html('');
    }
}



function get_service_packages(id){

    //    alert(id)
    if(id != ''){
        $.ajax({
            url: "/payments/"+id+"/update_service_packages/"
        });
    }else{
        $('#services').html('');
    }
}











function get_service_rates(id){
    $.ajax({
        url: "/services/"+id+"/update_service_rates/",
        success: function(data) {
            $('#rates').html(data);
        }
    });


}












function select_all_guests(total_guests){
    for(i = 0; i<=total_guests; i++){
        $('#guest_'+i).attr('checked', $('#total_guests').is(':checked'));
    }
}

//function select_all_services(total_services){
//    for(i = 0; i<=total_services; i++){
//        $('#service_'+i).attr('checked', $('#total_services').is(':checked'));
//    }
//}

function validate_guests_to_delete(total_guests){
    var valid = false;
    for(i = 0; i<=total_guests; i++){
        if($('#guest_'+i).is(':checked')){
            valid = true;
        }
    }
    if(!valid){
        alert("Please select atleast one guest to delete")
    }
    return valid;
}



function validate_services_to_delete(total_services){
    var valid = false;
    for(i = 0; i<=total_services; i++){
        if($('#service_'+i).is(':checked')){
            valid = true;
        }
    }
    if(!valid){
        alert("Please select atleast one service to delete")
    }
    return valid;
}


function update_service_status(id, status){
    $.ajax({
        url: "/services/"+id+"/update_status/",
        data: {
            status: status
        },
        type: 'put',
        success: function(data) {
            $('#status_'+id).html(data);
        }
    });
}

function select_all_services(total_services){
    for(i = 0; i<=total_services; i++){
        $('#service_'+i).attr('checked', $('#total_services').is(':checked'));
    }
}

function validate_services_to_delete(total_services){
    var valid = false;
    for(i = 0; i<=total_services; i++){
        if($('#service_'+i).is(':checked')){
            valid = true;
        }
    }
    if(!valid){
        alert("Please select atleast one service to delete")
    }
    return valid;
}





function update_package_status(id, status){
    $.ajax({
        url: "/packages/"+id+"/update_status/",
        data: {
            status: status
        },
        type: 'put',
        success: function(data) {
            $('#status_'+id).html(data);
        }
    });
}

function select_all_packages(total_packages){
    for(i = 0; i<=total_packages; i++){
        $('#package_'+i).attr('checked', $('#total_packages').is(':checked'));
    }
}

function validate_packages_to_delete(total_packages){
    var valid = false;
    for(i = 0; i<=total_packages; i++){
        if($('#package_'+i).is(':checked')){
            valid = true;
        }
    }
    if(!valid){
        alert("Please select atleast one package to delete")
    }
    return valid;
}






function update_profile_status(id, status){
    $.ajax({
        url: "/profiles/"+id+"/update_status/",
        data: {
            status: status
        },
        type: 'put',
        success: function(data) {
            $('#status_'+id).html(data);
        }
    });
}

function update_leave_status(id, leave_approval){
    $.ajax({
        url: "/manage_leaves/"+id+"/update_status/",
        data: {
            leave_approval: leave_approval
        },
        type: 'put',
        success: function(data) {
            $('#status_'+id).html(data);
        }
    });
}


function select_all_profiles(total_profiles){
    for(i = 0; i<=total_profiles; i++){
        $('#profile_'+i).attr('checked', $('#total_profiles').is(':checked'));
    }
}

function select_all_leaves(total_leaves){
    for(i = 0; i<=total_leaves; i++){
        $('#leave_'+i).attr('checked', $('#total_leaves').is(':checked'));
    }
}

function validate_profiles_to_delete(total_profiles){
    var valid = false;
    for(i = 0; i<=total_profiles; i++){
        if($('#profile_'+i).is(':checked')){
            valid = true;
        }
    }
    if(!valid){
        alert("Please select atleast one profiles to delete")
    }
    return valid;
}

function validate_leaves_to_delete(total_leaves){
    var valid = false;
    for(i = 0; i<=total_leaves; i++){
        if($('#leave_'+i).is(':checked')){
            valid = true;
        }
    }
    if(!valid){
        alert("Please select atleast one leave to delete")
    }
    return valid;
}








function update_product_status(id, status){
    $.ajax({
        url: "/products/"+id+"/update_status/",
        data: {
            status: status
        },
        type: 'put',
        success: function(data) {
            $('#status_'+id).html(data);
        }
    });
}

function select_all_products(total_products){
    for(i = 0; i<=total_products; i++){
        $('#product_'+i).attr('checked', $('#total_products').is(':checked'));
    }
}

function validate_products_to_delete(total_products){
    var valid = false;
    for(i = 0; i<=total_products; i++){
        if($('#product_'+i).is(':checked')){
            valid = true;
        }
    }
    if(!valid){
        alert("Please select atleast one product to delete")
    }
    return valid;
}















function display_textbox1(selected_value){
    alert(selected_value)
    if(selected_value == 'percentage'){
        $('#percentage_deposit').style.display = 'block'
    }
        
}

function get_comission_type(selected_value){
    if(selected_value == 'Percentage'){
        document.getElementById("percentage_field").style.display = 'block'
    }
    else
    {
        document.getElementById("percentage_field").style.display = 'none'
    }


}


function get_discount_type(selected_value){
    if(selected_value == 'Yes'){
        document.getElementById("percentage_field").style.display = 'block'
    }
    else
    {
        document.getElementById("percentage_field").style.display = 'none'
    }


}











function get_deposit_type(selected_value){
    if(selected_value == 'Percentage'){
        document.getElementById("percentage_field").style.display = 'block'
    }
    else
    {
        document.getElementById("percentage_field").style.display = 'none'
    }


}







function get_role_type(selected_value){
    if(selected_value == 'admin'){
        document.getElementById("get_role_type").style.display = 'block'
    }
    else
    {
        document.getElementById("get_role_type").style.display = 'none'
    }


}

function show_reward_point(selected_value){
    if (selected_value == '1'){
        document.getElementById("reward_point").style.display = 'block'
    //        document.getElementById("reward_point_title").style.display = 'block'
    }
    else
    {
        document.getElementById("reward_point").style.display = 'none'
    //        document.getElementById("reward_point_title").style.display = 'none'
    }
}
    
function show_benefit(selected_value){
    //    alert(selected_value)
    if (selected_value == '1'){
        document.getElementById("member_benefit_fields").style.display = 'block'
    }
    else
    {
        document.getElementById("member_benefit_fields").style.display = 'none'
    }
}















function update_role_status(id, status){
    $.ajax({
        url: "/roles/"+id+"/update_status/",
        data: {
            status: status
        },
        type: 'put',
        success: function(data) {
            $('#status_'+id).html(data);
        }
    });
}

function select_all_roles(total_roles){
    for(i = 0; i<=total_roles; i++){
        $('#role_'+i).attr('checked', $('#total_roles').is(':checked'));
    }
}

function validate_roles_to_delete(total_roles){
    var valid = false;
    for(i = 0; i<=total_roles; i++){
        if($('#role_'+i).is(':checked')){
            valid = true;
        }
    }
    if(!valid){
        alert("Please select atleast one role to delete")
    }
    return valid;
}






function update_role(id, role_id){
    $.ajax({
        url: "/users/"+id+"/update_name/",
        data: {
            role_id: role_id
        },
        type: 'put',
        success: function(data) {
            $('#name_'+id).html(data);
        }
    });
}








function update_location_status(id, status){
    $.ajax({
        url: "/locations/"+id+"/update_status/",
        data: {
            status: status
        },
        type: 'put',
        success: function(data) {
            $('#status_'+id).html(data);
        }
    });
}

function select_all_locations(total_locations){
    for(i = 0; i<=total_locations; i++){
        $('#location_'+i).attr('checked', $('#total_locations').is(':checked'));
    }
}

function validate_locations_to_delete(total_locations){
    var valid = false;
    for(i = 0; i<=total_locations; i++){
        if($('#location_'+i).is(':checked')){
            valid = true;
        }
    }
    if(!valid){
        alert("Please select atleast one location to delete")
    }
    return valid;
}

function update_taxtype_status(id, status){
    $.ajax({
        url: "/taxtypes/"+id+"/update_status/",
        data: {
            status: status
        },
        type: 'put',
        success: function(data) {
            $('#status_'+id).html(data);
        }
    });
}

function select_all_taxtypes(total_taxtypes){
    for(i = 0; i<=total_taxtypes; i++){
        $('#taxtype_'+i).attr('checked', $('#total_taxtypes').is(':checked'));
    }
}

function validate_taxtypes_to_delete(total_taxtypes){
    var valid = false;
    for(i = 0; i<=total_taxtypes; i++){
        if($('#taxtype_'+i).is(':checked')){
            valid = true;
        }
    }
    if(!valid){
        alert("Please select atleast one tax to delete")
    }
    return valid;
}




















function update_equipment_status(id, status){
    $.ajax({
        url: "/equipments/"+id+"/update_status/",
        data: {
            status: status
        },
        type: 'put',
        success: function(data) {
            $('#status_'+id).html(data);
        }
    });
}

function select_all_equipments(total_equipments){
    for(i = 0; i<=total_equipments; i++){
        $('#equipment_'+i).attr('checked', $('#total_equipments').is(':checked'));
    }
}

function validate_equipments_to_delete(total_equipments){
    var valid = false;
    for(i = 0; i<=total_equipments; i++){
        if($('#equipment_'+i).is(':checked')){
            valid = true;
        }
    }
    if(!valid){
        alert("Please select atleast one equipment to delete")
    }
    return valid;
}


function update_room_status(id, status){
    $.ajax({
        url: "/rooms/"+id+"/update_status/",
        data: {
            status: status
        },
        type: 'put',
        success: function(data) {
            $('#status_'+id).html(data);
        }
    });
}

function select_all_rooms(total_rooms){
    for(i = 0; i<=total_rooms; i++){
        $('#room_'+i).attr('checked', $('#total_rooms').is(':checked'));
    }
}

function validate_rooms_to_delete(total_rooms){
    var valid = false;
    for(i = 0; i<=total_rooms; i++){
        if($('#room_'+i).is(':checked')){
            valid = true;
        }
    }
    if(!valid){
        alert("Please select atleast one room to delete")
    }
    return valid;
}


















function update_employee_status(id, status){
    $.ajax({
        url: "/employees/"+id+"/update_status/",
        data: {
            status: status
        },
        type: 'put',
        success: function(data) {
            $('#status_'+id).html(data);
        }
    });
}

function select_all_employees(total_employees){
    for(i = 0; i<=total_employees; i++){
        $('#employee_'+i).attr('checked', $('#total_employees').is(':checked'));
    }
}

function validate_employees_to_delete(total_employees){
    var valid = false;
    for(i = 0; i<=total_employees; i++){
        if($('#employee_'+i).is(':checked')){
            valid = true;
        }
    }
    if(!valid){
        alert("Please select atleast one employee to delete")
    }
    return valid;
}




function update_membership_status(id, status){
    $.ajax({
        url: "/memberships/"+id+"/update_status/",
        data: {
            status: status
        },
        type: 'put',
        success: function(data) {
            $('#status_'+id).html(data);
        }
    });
}

function select_all_memberships(total_memberships){
    for(i = 0; i<=total_memberships; i++){
        $('#membership_'+i).attr('checked', $('#total_memberships').is(':checked'));
    }
}

function validate_memberships_to_delete(total_memberships){
    var valid = false;
    for(i = 0; i<=total_memberships; i++){
        if($('#membership_'+i).is(':checked')){
            valid = true;
        }
    }
    if(!valid){
        alert("Please select atleast one membership to delete")
    }
    return valid;
}
















































// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function moveEvent(event, dayDelta, minuteDelta, allDay){
    jQuery.ajax({
        data: 'id=' + event.id + '&title=' + event.title + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta + '&all_day=' + allDay,
        dataType: 'script',
        type: 'post',
        url: "/events/"+event.id+"/move"
    });
}

function resizeEvent(event, dayDelta, minuteDelta){
    jQuery.ajax({
        data: 'id=' + event.id + '&title=' + event.title + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta,
        dataType: 'script',
        type: 'post',
        url: "/events/"+event.id+"/resize"
    });
}

function showEventDetails(event){
    $('#event_desc').html(event.description);
    $('#edit_event').html("<a href = 'javascript:void(0);' onclick ='editEvent(" + event.id + ")'>Edit</a>");
    if (event.recurring) {
        title = event.title + "(Recurring)";
        $('#delete_event').html("&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + false + ")'>Delete Only This Occurrence</a>");
        $('#delete_event').append("&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + true + ")'>Delete All In Series</a>")
        $('#delete_event').append("&nbsp;&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", \"future\")'>Delete All Future Events</a>")
    }
    else {
        title = event.title;
        $('#delete_event').html("<a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + false + ")'>Delete</a>");
    }
    $('#desc_dialog').dialog({
        title: title,
        modal: true,
        width: 500,
        close: function(event, ui){
            $('#desc_dialog').dialog('destroy')
        }

    });

}


function editEvent(event_id){
    jQuery.ajax({
        dataType: 'script',
        type: 'get',
        url: "/events/"+event_id+"/edit"
    });
}

function deleteEvent(event_id, delete_all){
    jQuery.ajax({
        data: 'id=' + event_id + '&delete_all='+delete_all,
        dataType: 'script',
        type: 'delete',
        url: "/events/"+event_id
    });
}

function showPeriodAndFrequency(value){

    switch (value) {
        case 'Daily':
            $('#period').html('day');
            $('#frequency').show();
            break;
        case 'Weekly':
            $('#period').html('week');
            $('#frequency').show();
            break;
        case 'Monthly':
            $('#period').html('month');
            $('#frequency').show();
            break;
        case 'Yearly':
            $('#period').html('year');
            $('#frequency').show();
            break;

        default:
            $('#frequency').hide();
    }

}





function show_payment_type(payment_type){

    if(payment_type == 'Card'){
        $('#by_cash').hide();
        $('#by_card').show();
    }
    else
    {
        $('#by_card').hide();
        $('#by_cash').show(); 
    }
}









function calculate_payment_total_amount(){
    
}

function get_card_type(payment_type){

    if(payment_type == 'Card'){
        $('#by_cash').hide();
        $('#by_card').show();
    }
    else
    {
        $('#by_card').hide();
        $('#by_cash').show();
    }
}



function get_card_number(card_type_value){

    if(card_type_value){
        document.getElementById('cash').style.display = 'none'
        document.getElementById('card_number_field').style.display = 'block'
        document.getElementById('card_address').style.display = 'block'
    }
    else
    {
        document.getElementById('cash').style.display = 'block'
        document.getElementById('card_number_field').style.display = 'none'
        document.getElementById('card_address').style.display = 'none'
    }
}




function get_gender_type(gender_type){
    if(gender_type == 'Male'){
        $('#gender_type_male').show();
        $('#gender_type_female').hide();
    //        $('#by_card').show();
    }
    else 
    {             
        $('#gender_type_female').show();
        $('#gender_type_male').hide();
    }
}



function copy_previous_day_time(current_day, previous_day){
    previous_day_open = $('#'+previous_day+'_open').val();
    previous_day_close = $('#'+previous_day+'_close').val();
    $('#'+current_day+'_open').val(previous_day_open);
    $('#'+current_day+'_close').val(previous_day_close);
}

function show_operation_hours(schedule_type,id){
    if(schedule_type == 'regular'){
        day_range = [0,1,2,3,4,5,6]
        week_days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
        day_range.forEach(function(v) {
            $('#'+v).replaceWith(week_days[v]);
        });
    }
    else{
        $.ajax({
            url: "/locations/"+id+"/show_operation_hours_on_date?wkBegin="+schedule_type,
            type: 'get'
        });
    }
}

function update_operation_time(time_value, schedule_type, id, operate_date){
    $.ajax({
        url: "/locations/"+id+"/update_operation_time?operate_date="+operate_date+"&schedule_type="+schedule_type+"&time_value="+time_value,
        type: 'put',
        success: function(data) {
            $('#'+operate_date+'_'+schedule_type+'_update_status').html(data);
        }
    });
}

function get_service_type(service_type_value){
    if(service_type_value == 'Service'){
        $('#service_type').show();
        $('#package_type').hide();
    //        $('#by_card').show();
    }
    else
    {
        $('#package_type').show();
        $('#service_type').hide();
    }
}


function get_location_oulets(country, selected_id){
    if(country != ''){
        $.ajax({
            url: "/locations/get_outlets?country="+ country,
            type: 'get',
            success: function(data) {
                $('#'+selected_id).html(data);
            }
        });
    }
}

function validate_locations_selected(locations_array){
    valid = true;
    total_quantity_assigned = 0;
    total_out_service_assigned = 0;
    selected_locations_count = 0;
    $('#out_of_service_message').empty();
    $('#total_number_message').empty();
    if($('#equipment_total_number').val() == '' || parseInt($('#equipment_total_number').val()) == 0){
        $('#total_number_message').text('Quantity cant be blank or zero, please enter some value.')
        valid= false;
    }
    else if($('#equipment_no_out_of_service').val() == ''){
        $('#out_of_service_message').text('Number out of service cant be blank, please enter some value.')
        valid= false;
    }
    else if(parseInt($('#equipment_total_number').val()) < parseInt($('#equipment_no_out_of_service').val())){
        $('#out_of_service_message').text('Error, the number of equipments out of service should be less than total number of equipments.')
        valid= false;
    }
    else{
        for(i = 0; i<locations_array.length; i++){
            if($('#'+locations_array[i]+'_selected').is(':checked')) {
                selected_locations_count += 1;
                if(isNaN( $('#'+locations_array[i]+'_quantity').val()) || isNaN( $('#'+locations_array[i]+'_out_of_service').val())){
                    $('#'+locations_array[i]+'_message').text('Quantity and out of service equipments should be integer values.')
                    valid= false;
                }
                if(($('#'+locations_array[i]+'_quantity').val() == '') || ($('#'+locations_array[i]+'_out_of_service').val() == '')) {
                    $('#'+locations_array[i]+'_message').text('Please enter quantity and out of service equipments.')
                    valid= false;
                }
                else if(parseInt($('#'+locations_array[i]+'_quantity').val()) < parseInt($('#'+locations_array[i]+'_out_of_service').val())){
                    $('#'+locations_array[i]+'_message').empty();
                    $('#'+locations_array[i]+'_message').text('Out of service equipments should be less than the quantity.')
                    valid= false;
                }
                else{
                    total_quantity_assigned += parseInt($('#'+locations_array[i]+'_quantity').val());
                    total_out_service_assigned += parseInt($('#'+locations_array[i]+'_out_of_service').val());
                }
            }
        }
        if(selected_locations_count == 0){
            alert("Error, Please select atlease one location and assign equipments to that location.")
            valid= false;
        }
        else if((parseInt($('#equipment_total_number').val()) < total_quantity_assigned) || (parseInt($('#equipment_total_number').val()) != total_quantity_assigned)){
            $('#total_number_message').text('Error, Please check whether the quantity of equipments is equal to sum of those assigned to locations.')
            valid= false;
        }
        else if((parseInt($('#equipment_no_out_of_service').val()) < total_out_service_assigned) || (parseInt($('#equipment_no_out_of_service').val()) != total_out_service_assigned)){
            $('#out_of_service_message').text('Error, Please check whether the out of service equipments is equal to sum of those assigned to locations.')
            valid= false;
        }
    }
    return valid;
}

function update_location_equipment_status(id, update_status){
    $.ajax({
        url: "/equipments/update_location_equipment_status?location_equipment_id="+id+"&update_status="+update_status,
        type: 'put'
    });
}

function validate_products_selected_for_service(product_ids, check_type){
    var intRegex = /^\d+$/;
    valid = true;
    total_products_cost = 0;
    selected_products_count = 0;
    for(i = 0; i<product_ids.length; i++){
        if($('#'+product_ids[i]+'_selected').is(':checked')) {
            selected_products_count += 1;
            $('#'+product_ids[i]+'_message').empty();
            if($('#'+product_ids[i]+'_quantity').val() == ''){
                $('#'+product_ids[i]+'_message').text('Please enter the quantity.')
                valid = false;
            }else if($('#'+product_ids[i]+'_amount').val() == ''){
                $('#'+product_ids[i]+'_message').text('Please enter the cost for the selected quantity of product.')
                valid = false;
            }else if(parseInt($('#'+product_ids[i]+'_amount').val()) == 0){
                $('#'+product_ids[i]+'_message').text('Cost should be an integer value greater than zero.')
                valid = false;
            }else if(isNaN( $('#'+product_ids[i]+'_amount').val() )){
                $('#'+product_ids[i]+'_message').text('Cost should be an integer value greater than zero.')
                valid = false;
            }
            else{
                total_products_cost += parseInt($('#'+product_ids[i]+'_amount').val())
            }
        }
    }
    if(check_type == 'service'){
        real_values = 0;
        if($('#service_requires_equipment').is(':checked')){
            $('#service_equipment_ids :selected').each(function(i, selected){
                real_values = parseInt($(selected).val());
            })
            if(real_values <= 0){
                $('#equipment_error').text('Select atleast one equipment.')
                valid = false;
            }

        }
    }
    if(valid){
        if(selected_products_count == 0){
            if(confirm("You have not selected any product in this service, do you want to continue creating product?")){
                valid = true;
            } else{
                valid = false;
            }
        }else if(valid != false){
            alert("The total cost of all the selected products is "+total_products_cost+".")
        }
    }
    return valid;
}

function validate_payment(){
    valid = false;
    if($('#amount_paid').val() == ''){
        $('#amount_paid_message').text('Amount should not be blank.')
    }else if($('#balance_due').val() == ''){
        $('#balance_due_message').text('Balance should not be blank.')
    }
    else if(isNaN( $('#amount_paid').val()) || parseInt($('#amount_paid').val()) == 0){
        $('#amount_paid_message').text('Amount should be an integer value greater than zero.')
    }else if(isNaN( $('#balance_due').val()) || parseInt($('#balance_due').val()) == 0){
        $('#balance_due_message').text('Balance  should be an integer value.')
    }
    else if(parseInt($('#total').val()) < parseInt($('#amount_paid').val())){
        $('#amount_paid_message').text('Entered amount greater than total.')
    }else if(parseInt($('#balance_due').val()) > parseInt($('#total').val())){
        $('#balance_due_message').text('Balance is more than the total.')
    }else{
        valid = true;
    }
    return valid;
}



function show_gift_voucher(selected_value){
    if (selected_value == '1'){
        $('#gift_voucher').show();
    //        document.getElementById("reward_point_title").style.display = 'block'
    }
    else
    {
     $('#gift_voucher').hide();
    //        document.getElementById("reward_point_title").style.display = 'none'
    }
}

function validate_locations_products(locations_array, product_quantity){
    valid = true;
    total_quantity_assigned = 0;
    selected_locations_count = 0;
    for(i = 0; i<locations_array.length; i++){
        if($('#'+locations_array[i]+'_selected').is(':checked')) {
            selected_locations_count += 1;
            $('#'+locations_array[i]+'_message').empty();
            if(isNaN( $('#'+locations_array[i]+'_quantity').val())){
                $('#'+locations_array[i]+'_message').text('Quantity should be an integer value.')
                valid= false;
            }
            if($('#'+locations_array[i]+'_quantity').val() == '') {
                $('#'+locations_array[i]+'_message').text('Please enter quantity assigned.')
                valid= false;
            }
            else{
                total_quantity_assigned += parseInt($('#'+locations_array[i]+'_quantity').val());
            }
        }
    }
    if(selected_locations_count == 0){
        $('#assign_locations_message').text("You have not assigned products to any location, please assign and continue");
        valid= false;
    }else if(total_quantity_assigned != product_quantity){
        $('#assign_locations_message').text('The sum of products assigned to location is not equal to the quantity of the product, please verify.')
        valid= false;
    }
    return valid;
}