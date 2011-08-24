/* 
   Simple JQuery Collapsing menu.
   HTML structure to use:

   <ul id="menu">
     <li><a href="#">Sub menu heading</a>
     <ul>
       <li><a href="http://site.com/">Link</a></li>
       <li><a href="http://site.com/">Link</a></li>
       <li><a href="http://site.com/">Link</a></li>
       ...
       ...
     </ul>
     <li><a href="#">Sub menu heading</a>
     <ul>
       <li><a href="http://site.com/">Link</a></li>
       <li><a href="http://site.com/">Link</a></li>
       <li><a href="http://site.com/">Link</a></li>
       ...
       ...
     </ul>
     ...
     ...
   </ul>

Copyright 2007 by Marco van Hylckama Vlieg

web: http://www.i-marco.nl/weblog/
email: marco@i-marco.nl

Free for non-commercial use
 */




//function initMenu() {
//    $('#menu ul').hide();
//    $('#menu li a').click(
//        function() {
//            $(this).next().slideToggle('normal');
//        }
//        );
//}
//$(document).ready(function() {
//    initMenu();
//});
//


function initMenu() {
    $('#menu ul').hide();
    $('#menu li a').click(
        function() {
            
            current_link_html = $(this).html();
            current_link_html_id = current_link_html.split('"', 2)[1]
            content_html = $('#'+current_link_html_id).html();
            if(content_html == '+ '){
                $('#'+current_link_html_id).html('- ');
            }else{
                $('#'+current_link_html_id).html('+ ');
            }
            $(this).next().slideToggle('normal');
        }
        );




            

}
$(document).ready(function() {
    initMenu();
//       $(this).initMenu('expanded');
});