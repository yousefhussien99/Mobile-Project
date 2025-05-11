from django.urls import path
from .views import product_list, product_detail, store_product_list, store_product_detail, add_product, add_store_product, update_product ,update_store_product, delete_product, delete_store_product,store_product_detail_by_name_of_product


urlpatterns = [
    path('products/', product_list, name='product-list'),
    path('products/<int:product_id>/', product_detail, name='product-detail'),
    path('store/<int:store_id>/products/', store_product_list, name='store-product-list'),
    path('store/products/<int:product_id>/', store_product_detail, name='store-product-detail'),
    path('store/products/name/', store_product_detail_by_name_of_product, name='store-product-detail-by-name'),
    path('products/add/', add_product, name='add-product'),
    path('store/products/add/', add_store_product, name='add-store-product'),
    path('products/update/<int:product_id>/', update_product, name='update-product'),
    path('store/products/update/<int:store_product_id>/', update_store_product, name='update-store-product'),
    path('products/delete/<int:product_id>/', delete_product, name='delete-product'),
    path('store/products/delete/<int:store_product_id>/', delete_store_product, name='delete-store-product' ),
]

