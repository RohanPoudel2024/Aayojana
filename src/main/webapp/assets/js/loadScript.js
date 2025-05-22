// Script references for event details page
document.addEventListener('DOMContentLoaded', function() {
    // Add script tag to load external JS file
    var scriptElement = document.createElement('script');
    scriptElement.src = document.querySelector('link[href*="eventDetails.css"]').href.replace('css/eventDetails.css', 'js/eventDetails.js');
    document.body.appendChild(scriptElement);
});
