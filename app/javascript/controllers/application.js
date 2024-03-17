import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

document.addEventListener("touchstart", function(){}, true);
document.addEventListener('DOMContentLoaded', function() {
        FastClick.attach(document.body);
    }, false);
    
export { application }
