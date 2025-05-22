document.addEventListener('DOMContentLoaded', function() {
    // Initialize AOS animation library if available
    if (typeof AOS !== 'undefined') {
        AOS.init({
            duration: 800,
            easing: 'ease-in-out',
            once: true,
            mirror: false
        });
    }
    
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

    // Initialize hero section particles if particles.js is available
    initHeroParticles();
    
    // Setup smooth scroll behavior for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const targetId = this.getAttribute('href');
            
            if(targetId !== '#') {
                const targetElement = document.querySelector(targetId);
                
                if(targetElement) {
                    // Smooth scroll to the element
                    window.scrollTo({
                        top: targetElement.offsetTop - 80, // Adjust for header
                        behavior: 'smooth'
                    });
                }
            }
        });
    });

    // Initialize share panel functionality
    setupSharePanel();
    
    // Handle scroll indicator
    var scrollIndicator = document.querySelector('.scroll-indicator');
    if (scrollIndicator) {
        scrollIndicator.addEventListener('click', function() {
            window.scrollTo({
                top: document.querySelector('#event-details').offsetTop - 80,
                behavior: 'smooth'
            });
        });
        
        // Hide scroll indicator when scrolled
        window.addEventListener('scroll', function() {
            if (window.scrollY > 300) {
                scrollIndicator.style.opacity = '0';
            } else {
                scrollIndicator.style.opacity = '1';
            }
        });
    }

    // Lightbox functionality for gallery images
    var albumImages = document.querySelectorAll('.album-image');
    albumImages.forEach(function(image) {
        image.addEventListener('click', function() {
            var img = this.querySelector('img');
            var caption = this.querySelector('.caption');
            
            createLightbox(img.src, caption ? caption.textContent : null);
        });
    });

    // Handle floating action button visibility
    var fab = document.querySelector('.floating-action-btn');
    var footer = document.querySelector('footer');
    if (fab && footer) {
        window.addEventListener('scroll', function() {
            var footerRect = footer.getBoundingClientRect();
            
            // Hide FAB when footer is visible
            if (footerRect.top < window.innerHeight) {
                fab.classList.add('fab-hidden');
            } else {
                fab.classList.remove('fab-hidden');
            }
        });
    }
    
    // Animate elements on scroll
    var animateOnScroll = function() {
        var elements = document.querySelectorAll('.section:not(.animate-active)');
        
        elements.forEach(function(element) {
            var elementPosition = element.getBoundingClientRect().top;
            var screenPosition = window.innerHeight / 1.2;
            
            if (elementPosition < screenPosition) {
                element.classList.add('animate-active');
                if (!element.style.animation) {
                    element.style.animation = 'fadeInUp 0.8s ease-out forwards';
                }
            }
        });
    };
    
    // Initial check
    animateOnScroll();
    
    // Listen for scroll
    window.addEventListener('scroll', animateOnScroll);
    
    // Animate event items with staggered delay
    var eventItems = document.querySelectorAll('.event-item');
    
    eventItems.forEach(function(item, index) {
        setTimeout(function() {
            item.style.opacity = '0';
            item.style.transform = 'translateY(20px)';
            
            setTimeout(function() {
                item.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
                item.style.opacity = '1';
                item.style.transform = 'translateY(0)';
            }, 100);
        }, index * 150);
    });
    
    // Hover effects for buttons
    var buttons = document.querySelectorAll('.btn, .cta-btn, .hero-btn');
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
    
    // Toggle description for read more
    window.toggleDescription = function(e) {
        e.preventDefault();
        var aboutDetails = document.querySelector('.about-details');
        aboutDetails.classList.toggle('expanded');
        
        var readMoreBtn = document.querySelector('.read-more');
        if (aboutDetails.classList.contains('expanded')) {
            readMoreBtn.textContent = 'Read less';
        } else {
            readMoreBtn.textContent = 'Read more';
        }
    };
});

// Initialize hero section particles effect
function initHeroParticles() {
    var heroParticles = document.getElementById('hero-particles');
    
    if (heroParticles && typeof particlesJS !== 'undefined') {
        particlesJS('hero-particles', {
            "particles": {
                "number": {
                    "value": 80,
                    "density": {
                        "enable": true,
                        "value_area": 800
                    }
                },
                "color": {
                    "value": "#ffffff"
                },
                "shape": {
                    "type": "circle",
                    "stroke": {
                        "width": 0,
                        "color": "#000000"
                    },
                    "polygon": {
                        "nb_sides": 5
                    }
                },
                "opacity": {
                    "value": 0.5,
                    "random": false,
                    "anim": {
                        "enable": false,
                        "speed": 1,
                        "opacity_min": 0.1,
                        "sync": false
                    }
                },
                "size": {
                    "value": 3,
                    "random": true,
                    "anim": {
                        "enable": false,
                        "speed": 40,
                        "size_min": 0.1,
                        "sync": false
                    }
                },
                "line_linked": {
                    "enable": true,
                    "distance": 150,
                    "color": "#ffffff",
                    "opacity": 0.4,
                    "width": 1
                },
                "move": {
                    "enable": true,
                    "speed": 2,
                    "direction": "none",
                    "random": false,
                    "straight": false,
                    "out_mode": "out",
                    "bounce": false,
                    "attract": {
                        "enable": false,
                        "rotateX": 600,
                        "rotateY": 1200
                    }
                }
            },
            "interactivity": {
                "detect_on": "canvas",
                "events": {
                    "onhover": {
                        "enable": true,
                        "mode": "grab"
                    },
                    "onclick": {
                        "enable": true,
                        "mode": "push"
                    },
                    "resize": true
                },
                "modes": {
                    "grab": {
                        "distance": 140,
                        "line_linked": {
                            "opacity": 1
                        }
                    },
                    "bubble": {
                        "distance": 400,
                        "size": 40,
                        "duration": 2,
                        "opacity": 8,
                        "speed": 3
                    },
                    "repulse": {
                        "distance": 200,
                        "duration": 0.4
                    },
                    "push": {
                        "particles_nb": 4
                    },
                    "remove": {
                        "particles_nb": 2
                    }
                }
            },
            "retina_detect": true
        });
    } else if (heroParticles) {
        // If particles.js is not available, add a basic animation
        for (var i = 0; i < 50; i++) {
            var particle = document.createElement('div');
            particle.className = 'particle';
            particle.style.left = Math.random() * 100 + '%';
            particle.style.top = Math.random() * 100 + '%';
            particle.style.width = Math.random() * 5 + 1 + 'px';
            particle.style.height = particle.style.width;
            particle.style.opacity = Math.random() * 0.5 + 0.3;
            particle.style.backgroundColor = 'white';
            particle.style.borderRadius = '50%';
            particle.style.position = 'absolute';
            particle.style.animation = 'float ' + (Math.random() * 10 + 5) + 's linear infinite';
            heroParticles.appendChild(particle);
        }
    }
}

// Show event map with Google Maps iframe
function showEventMap() {
    var mapContainer = document.getElementById('event-map');
    var location = document.querySelector('.location-title').textContent;
    
    if (mapContainer) {
        // Show loading indicator
        var loadingIndicator = document.createElement('div');
        loadingIndicator.className = 'map-loading';
        loadingIndicator.innerHTML = '<div class="map-spinner"></div>';
        mapContainer.appendChild(loadingIndicator);
        
        // Clear placeholder
        var placeholder = mapContainer.querySelector('.map-placeholder');
        if (placeholder) {
            placeholder.style.display = 'none';
        }
        
        // Create and add the iframe
        setTimeout(function() {
            var iframe = document.createElement('iframe');
            iframe.src = 'https://maps.google.com/maps?q=' + encodeURIComponent(location) + '&t=&z=13&ie=UTF8&iwloc=&output=embed';
            iframe.frameBorder = '0';
            iframe.scrolling = 'no';
            iframe.marginHeight = '0';
            iframe.marginWidth = '0';
            iframe.style.width = '100%';
            iframe.style.height = '100%';
            iframe.style.borderRadius = '12px';
            
            iframe.onload = function() {
                // Remove loading indicator
                mapContainer.removeChild(loadingIndicator);
            };
            
            mapContainer.appendChild(iframe);
        }, 1000);
    }
}

// Setup share panel functionality
function setupSharePanel() {
    var shareBtn = document.getElementById('shareBtn');
    var sharePanel = document.getElementById('sharePanel');
    var closePanel = document.getElementById('closePanel');
    var copyLinkBtn = document.getElementById('copyLinkBtn');
    var shareSuccess = document.getElementById('shareSuccess');
    
    if (shareBtn && sharePanel) {
        // Show share panel
        shareBtn.addEventListener('click', function() {
            sharePanel.classList.add('active');
        });
        
        // Close share panel
        if (closePanel) {
            closePanel.addEventListener('click', function() {
                sharePanel.classList.remove('active');
            });
        }
        
        // Close on outside click
        sharePanel.addEventListener('click', function(e) {
            if (e.target === sharePanel) {
                sharePanel.classList.remove('active');
            }
        });
        
        // Copy link functionality
        if (copyLinkBtn && shareSuccess) {
            copyLinkBtn.addEventListener('click', function() {
                var eventLink = document.getElementById('eventLink');
                if (eventLink) {
                    eventLink.select();
                    document.execCommand('copy');
                    
                    // Show success message
                    shareSuccess.classList.add('active');
                    
                    // Hide after 3 seconds
                    setTimeout(function() {
                        shareSuccess.classList.remove('active');
                    }, 3000);
                }
            });
        }
    }
}

// Share event on social media
function shareEvent(platform) {
    var eventTitle = document.querySelector('.event-title').textContent;
    var eventLink = document.getElementById('eventLink').value;
    var shareUrl = '';
    
    switch(platform) {
        case 'facebook':
            shareUrl = 'https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(eventLink);
            break;
        case 'twitter':
            shareUrl = 'https://twitter.com/intent/tweet?text=' + encodeURIComponent('Check out this event: ' + eventTitle) + '&url=' + encodeURIComponent(eventLink);
            break;
        case 'whatsapp':
            shareUrl = 'https://api.whatsapp.com/send?text=' + encodeURIComponent('Check out this event: ' + eventTitle + ' ' + eventLink);
            break;
        case 'email':
            shareUrl = 'mailto:?subject=' + encodeURIComponent('Check out this event: ' + eventTitle) + '&body=' + encodeURIComponent('I thought you might be interested in this event: ' + eventTitle + '\n\n' + eventLink);
            break;
    }
    
    if (shareUrl) {
        window.open(shareUrl, '_blank');
    }
}

// Create a lightbox for gallery images
function createLightbox(imgSrc, caption) {    // Create lightbox container
    var lightbox = document.createElement('div');
    lightbox.className = 'lightbox animate-fadeIn';
    lightbox.style.cssText = 'position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.9); display: flex; align-items: center; justify-content: center; z-index: 9999; padding: 2rem';
      // Create image container
    var imgContainer = document.createElement('div');
    imgContainer.style.cssText = 'position: relative; max-width: 90%; max-height: 80%';
    imgContainer.className = 'animate-scaleIn';    // Create image
    var img = document.createElement('img');
    img.src = imgSrc;
    img.style.cssText = 'max-width: 100%; max-height: 80vh; object-fit: contain; border-radius: 8px; box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3)';    // Close button
    var closeBtn = document.createElement('button');
    closeBtn.innerHTML = '&times;';
    closeBtn.style.cssText = 'position: absolute; top: -20px; right: -20px; background-color: white; color: #18181b; border-radius: 50%; width: 40px; height: 40px; font-size: 24px; border: none; cursor: pointer; display: flex; align-items: center; justify-content: center; box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2)';
    
    // Caption
    if (caption) {
        var captionElement = document.createElement('div');
        captionElement.textContent = caption;
        captionElement.style.cssText = 'color: white; text-align: center; margin-top: 1rem; font-size: 1rem; font-weight: 500';
        imgContainer.appendChild(captionElement);
    }
    
    // Add elements to DOM
    imgContainer.appendChild(img);
    imgContainer.appendChild(closeBtn);
    lightbox.appendChild(imgContainer);
    document.body.appendChild(lightbox);
    
    // Close on click
    closeBtn.addEventListener('click', function() {
        lightbox.classList.add('animate-fadeOut');
        setTimeout(function() {
            document.body.removeChild(lightbox);
        }, 300);
    });
    
    // Close on outside click
    lightbox.addEventListener('click', function(e) {
        if (e.target === lightbox) {
            lightbox.classList.add('animate-fadeOut');
            setTimeout(function() {
                document.body.removeChild(lightbox);
            }, 300);
        }
    });
}
