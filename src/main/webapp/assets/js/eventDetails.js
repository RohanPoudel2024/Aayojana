// Fixed event details JavaScript
document.addEventListener('DOMContentLoaded', function() {
    // Initialize page transition
    var pageTransition = document.querySelector('.page-transition');
    if (pageTransition) {
        setTimeout(function() {
            pageTransition.classList.remove('active');
        }, 500);
    }

    // Handle all page links for transitions
    var links = document.querySelectorAll('a:not([target="_blank"])');
    links.forEach(function(link) {
        if (link.href && 
            !link.href.startsWith('#') && 
            !link.href.startsWith('javascript:')) {
            
            link.addEventListener('click', function(e) {
                if (pageTransition) {
                    e.preventDefault();
                    pageTransition.classList.add('active');
                    
                    setTimeout(function() {
                        window.location.href = link.href;
                    }, 500);
                }
            });
        }
    });

    // Lightbox functionality for gallery images
    var albumImages = document.querySelectorAll('.album-image');
    albumImages.forEach(function(image) {
        image.addEventListener('click', function() {
            var img = this.querySelector('img');
            var caption = this.querySelector('.caption');
            
            // Create lightbox elements
            var lightbox = document.createElement('div');
            lightbox.className = 'lightbox animate-fadeIn';
            lightbox.style.cssText = 'position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.9); display: flex; align-items: center; justify-content: center; z-index: 9999; padding: 2rem;';
            
            var container = document.createElement('div');
            container.style.cssText = 'position: relative; max-width: 90%; max-height: 80%;';
            container.className = 'animate-scaleIn';
            
            var imgElement = document.createElement('img');
            imgElement.src = img.src;
            imgElement.style.cssText = 'max-width: 100%; max-height: 80vh; object-fit: contain; border-radius: 8px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);';
            
            var closeBtn = document.createElement('button');
            closeBtn.innerHTML = '&times;';
            closeBtn.style.cssText = 'position: absolute; top: -20px; right: -20px; background-color: white; color: #18181b; border-radius: 50%; width: 40px; height: 40px; font-size: 24px; border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);';
            
            container.appendChild(imgElement);
            container.appendChild(closeBtn);
            lightbox.appendChild(container);
            
            // Add caption if it exists
            if (caption) {
                var captionElement = document.createElement('div');
                captionElement.textContent = caption.textContent;
                captionElement.style.cssText = 'color: white; text-align: center; margin-top: 1rem; font-size: 1rem; font-weight: 500;';
                container.appendChild(captionElement);
            }
            
            document.body.appendChild(lightbox);
            
            // Close lightbox
            function closeLightbox() {
                lightbox.style.opacity = '0';
                setTimeout(function() {
                    if (document.body.contains(lightbox)) {
                        document.body.removeChild(lightbox);
                    }
                }, 300);
            }
            
            closeBtn.addEventListener('click', closeLightbox);
            lightbox.addEventListener('click', function(e) {
                if (e.target === lightbox) {
                    closeLightbox();
                }
            });
        });
    });

    // Toggle read more description
    var readMoreBtn = document.querySelector('.read-more');
    if (readMoreBtn) {
        readMoreBtn.addEventListener('click', function(e) {
            e.preventDefault();
            var aboutDetails = document.querySelector('.about-details');
            aboutDetails.classList.toggle('expanded');
            
            if (aboutDetails.classList.contains('expanded')) {
                this.textContent = 'Read less';
            } else {
                this.textContent = 'Read more';
            }
        });
    }

    // Handle floating action button
    var fab = document.querySelector('.floating-action-btn');
    var footer = document.querySelector('footer');
    
    if (fab && footer) {
        window.addEventListener('scroll', function() {
            var footerRect = footer.getBoundingClientRect();
            if (footerRect.top < window.innerHeight) {
                fab.classList.add('fab-hidden');
            } else {
                fab.classList.remove('fab-hidden');
            }
        });
    }

    // Animate sections on scroll
    function animateOnScroll() {
        var sections = document.querySelectorAll('.section:not(.animate-active)');
        
        sections.forEach(function(section) {
            var position = section.getBoundingClientRect().top;
            var screenPosition = window.innerHeight / 1.2;
            
            if (position < screenPosition) {
                section.classList.add('animate-active');
                section.style.animation = 'fadeInUp 0.8s ease-out forwards';
            }
        });
    }
    
    // Initial check and scroll listener
    animateOnScroll();
    window.addEventListener('scroll', animateOnScroll);

    // Add hover effects to buttons
    var buttons = document.querySelectorAll('.btn, .cta-btn');
    buttons.forEach(function(button) {
        button.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
            this.style.boxShadow = '0 10px 20px rgba(0, 0, 0, 0.15)';
        });
        
        button.addEventListener('mouseleave', function() {
            this.style.transform = '';
            this.style.boxShadow = '';
        });
    });
});
