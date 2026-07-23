"""
Store Admin — Product categories, products, and images with inline editing.
"""

from django.contrib import admin
from django.utils.html import format_html
from .models import ProductCategory, Product, ProductImage


class ProductImageInline(admin.TabularInline):
    model = ProductImage
    extra = 1
    fields = ['image', 'image_preview', 'alt_text', 'is_primary']
    readonly_fields = ['image_preview']

    def image_preview(self, obj):
        if obj.image:
            return format_html(
                '<img src="{}" style="max-height: 60px; border-radius: 4px;" />',
                obj.image.url,
            )
        return '-'
    image_preview.short_description = 'Preview'


@admin.register(ProductCategory)
class ProductCategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'slug', 'product_count', 'is_active', 'sort_order']
    list_filter = ['is_active']
    search_fields = ['name']
    prepopulated_fields = {'slug': ('name',)}
    list_editable = ['sort_order', 'is_active']

    def product_count(self, obj):
        return obj.products.count()
    product_count.short_description = 'Products'


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = [
        'name', 'category', 'price_display', 'stock_quantity',
        'rating', 'is_featured', 'is_active', 'created_at',
    ]
    list_filter = ['category', 'is_featured', 'is_active', 'created_at']
    search_fields = ['name', 'description', 'slug']
    prepopulated_fields = {'slug': ('name',)}
    list_editable = ['is_featured', 'is_active']
    raw_id_fields = ['vendor']
    inlines = [ProductImageInline]
    readonly_fields = ['effective_price', 'discount_percentage']
    actions = ['make_featured', 'remove_featured']

    fieldsets = (
        (None, {'fields': ('name', 'slug', 'category', 'vendor')}),
        ('Pricing', {'fields': ('price', 'discount_price', 'unit', 'effective_price', 'discount_percentage')}),
        ('Details', {'fields': ('description', 'stock_quantity')}),
        ('Ratings', {'fields': ('rating', 'rating_count')}),
        ('Status', {'fields': ('is_active', 'is_featured')}),
    )

    def price_display(self, obj):
        if obj.discount_price:
            return format_html(
                '<span style="text-decoration: line-through; color: #999;">৳{}</span> '
                '<span style="color: #22C55E; font-weight: bold;">৳{}</span>',
                obj.price, obj.discount_price,
            )
        return f'৳{obj.price}'
    price_display.short_description = 'Price'

    @admin.action(description='Mark selected as Featured')
    def make_featured(self, request, queryset):
        queryset.update(is_featured=True)

    @admin.action(description='Remove from Featured')
    def remove_featured(self, request, queryset):
        queryset.update(is_featured=False)
