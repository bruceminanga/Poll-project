from django.contrib import admin
from django.urls import include, path  # Add include

urlpatterns = [
    path("polls/", include("polls.urls")),  # Include polls app URLs
    path("admin/", admin.site.urls),
]
