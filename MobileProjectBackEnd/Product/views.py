from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from .models import Product ,StoreProduct
from Store.models import Store
from .serializers import ProductSerializer ,StoreProductSerializer
from Store.serializers import StoreSerializer


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def product_list(request):
    products = Product.objects.all()
    serializer = ProductSerializer(products, many=True)
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def product_detail(request, product_id):
    try:
        product = Product.objects.get(id=product_id)
    except Product.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    serializer = ProductSerializer(product)
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def store_product_list(request, store_id):
    products = StoreProduct.objects.filter(store_id=store_id)
    serializer = StoreProductSerializer(products, many=True)
    data = []
    for sp in serializer.data:
        store = Store.objects.get(id=sp['store'])
        product = Product.objects.get(id=sp['product'])
        data.append({
            "id": sp['id'],
            "productName": product.name,
            "description": product.description,
            "quantity": sp['quantity'],
            "price": sp['price'],
            "imageProduct": product.imgUrl,
            "store": {
                "id": store.id,
                "name": store.name,
                "type": store.type,
                "location": store.location,
                "latitude": store.latitude,
                "longitude": store.longitude,
                "imgUrl": store.imgUrl,
            }
        })
    return Response(data)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def store_product_detail(request, product_id):
    store_products = StoreProduct.objects.filter(product_id=product_id)
    if not store_products.exists():
        return Response(status=status.HTTP_404_NOT_FOUND)
    data = []
    for sp in store_products:
        store = sp.store
        data.append({
            "id": store.id,
            "name": store.name,
            "type": store.type,
            "location": store.location,
            "latitude": store.latitude,
            "longitude": store.longitude,
            "imgUrl": store.imgUrl,
            "price": sp.price,
            "quantity": sp.quantity,
        })
    return Response(data)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def store_product_detail_by_name_of_product(request):
    product_name = request.query_params.get('product_name')
    print("product_name", product_name)

    products = Product.objects.filter(name=product_name)

    if not products.exists():
        return Response({'detail': 'Product not found.'}, status=status.HTTP_404_NOT_FOUND)

    data = []
    for product in products:
        store_products = StoreProduct.objects.filter(product=product)
        if not store_products.exists():
            continue  # Skip products that aren't in any store

        for sp in store_products:
            store = sp.store
            data.append({
                "id": store.id,
                "product_name": product.name,
                "description": product.description,
                "quantity": sp.quantity,
                "price": sp.price,
                "imageProduct": product.imgUrl,
                "store": {
                    "id": store.id,
                    "name": store.name,
                    "type": store.type,
                    "location": store.location,
                    "latitude": store.latitude,
                    "longitude": store.longitude,
                    "imgUrl": store.imgUrl,
                }
            })

    if not data:
        return Response({'detail': 'No stores found for this product.'}, status=status.HTTP_404_NOT_FOUND)

    return Response(data)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_product(request):
    serializer = ProductSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_store_product(request):
    serializer = StoreProductSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['PUT'])
@permission_classes([IsAuthenticated])
def update_product(request, product_id):
    try:
        product = Product.objects.get(id=product_id)
    except Product.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    serializer = ProductSerializer(product, data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
@api_view(['PUT'])
@permission_classes([IsAuthenticated])
def update_store_product(request, store_product_id):
    try:
        store_product = StoreProduct.objects.get(id=store_product_id)
    except StoreProduct.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    serializer = StoreProductSerializer(store_product, data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def delete_product(request, product_id):
    try:
        product = Product.objects.get(id=product_id)
    except Product.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    product.delete()
    return Response(status=status.HTTP_204_NO_CONTENT)
@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def delete_store_product(request, store_product_id):
    try:
        store_product = StoreProduct.objects.get(id=store_product_id)
    except StoreProduct.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    store_product.delete()
    return Response(status=status.HTTP_204_NO_CONTENT)
