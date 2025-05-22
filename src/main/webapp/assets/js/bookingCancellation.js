// Enhanced booking cancellation confirmation
document.addEventListener('DOMContentLoaded', function() {
    // Find any booking cancellation forms
    const cancellationForms = document.querySelectorAll('form[action*="/booking"][method="post"]');
    
    cancellationForms.forEach(form => {
        form.addEventListener('submit', function(event) {
            // Basic confirmation dialog is already handled with onsubmit="return confirm('message')"
            // This is just for future enhancements if needed
            
            // You could implement a custom modal dialog here instead of the browser's confirm
            // For example:
            // event.preventDefault();
            // showCustomConfirmDialog('Are you sure you want to cancel your booking?', () => {
            //     form.submit();
            // });
        });
    });
    
    // Handle success messages
    const successMessage = document.querySelector('.success-message');
    if (successMessage) {
        // Auto-hide the message after 5 seconds
        setTimeout(() => {
            successMessage.style.opacity = '0';
            setTimeout(() => {
                successMessage.style.display = 'none';
            }, 500);
        }, 5000);
    }
    
    // Handle error messages
    const errorMessage = document.querySelector('.error-message');
    if (errorMessage) {
        // Auto-hide the message after 5 seconds
        setTimeout(() => {
            errorMessage.style.opacity = '0';
            setTimeout(() => {
                errorMessage.style.display = 'none';
            }, 500);
        }, 5000);
    }
});

// Custom confirmation dialog (for future implementation)
function showCustomConfirmDialog(message, confirmCallback) {
    const overlay = document.createElement('div');
    overlay.style.position = 'fixed';
    overlay.style.top = '0';
    overlay.style.left = '0';
    overlay.style.width = '100%';
    overlay.style.height = '100%';
    overlay.style.backgroundColor = 'rgba(0, 0, 0, 0.5)';
    overlay.style.display = 'flex';
    overlay.style.justifyContent = 'center';
    overlay.style.alignItems = 'center';
    overlay.style.zIndex = '1000';
    
    const dialog = document.createElement('div');
    dialog.className = 'confirm-dialog';
    
    const title = document.createElement('div');
    title.className = 'confirm-dialog-title';
    title.textContent = message;
    
    const buttonContainer = document.createElement('div');
    buttonContainer.className = 'confirm-dialog-buttons';
    
    const cancelButton = document.createElement('button');
    cancelButton.textContent = 'Cancel';
    cancelButton.className = 'btn';
    cancelButton.addEventListener('click', () => {
        document.body.removeChild(overlay);
    });
    
    const confirmButton = document.createElement('button');
    confirmButton.textContent = 'Confirm';
    confirmButton.className = 'btn btn-danger';
    confirmButton.addEventListener('click', () => {
        document.body.removeChild(overlay);
        confirmCallback();
    });
    
    buttonContainer.appendChild(cancelButton);
    buttonContainer.appendChild(confirmButton);
    
    dialog.appendChild(title);
    dialog.appendChild(buttonContainer);
    
    overlay.appendChild(dialog);
    document.body.appendChild(overlay);
}
