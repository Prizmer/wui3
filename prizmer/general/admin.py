from django.contrib import admin
from general.models import Objects, Abonents, Comments, TypesAbonents, Meters, MonthlyValues, DailyValues, CurrentValues, VariousValues, TypesParams, Params, TakenParams, LinkAbonentsTakenParams, Resources, TypesMeters, Measurement, NamesParams, BalanceGroups, LinkMetersComportSettings, LinkMetersTcpipSettings, ComportSettings, TcpipSettings, LinkBalanceGroupsMeters, Groups80020, LinkGroups80020Meters, LinkAbonentsAuthUser, ReportConfig
from django.conf import settings

# === КАСТОМИЗАЦИЯ ЗАГОЛОВКОВ АДМИНКИ ===
from django.contrib import admin
from django.conf import settings

# === КАСТОМИЗАЦИЯ ЗАГОЛОВКОВ АДМИНКИ ===
if settings.IS_RIDAN:
    admin.site.site_header = 'РИДАН'        
    admin.site.site_title = 'РИДАН'
    admin.site.index_title = 'Панель администрирования'
else:
    admin.site.site_header = 'ПАК "Правильные Измерения"'
    admin.site.site_title = 'ПАК "Правильные Измерения"'
    admin.site.index_title = 'Панель администрирования'

# Register your models here.
class LinkAbonentsTakenParamsAdmin(admin.ModelAdmin):
    list_select_related = True
    search_fields = ['name']

class MetersAdmin(admin.ModelAdmin):
    search_fields = ['name']
    date_hierarchy = 'dt_last_read'
    list_display = ('name','factory_number_manual', 'address', 'dt_last_read', 'is_factory_numbers_equal')
    
class AbonentsAdmin(admin.ModelAdmin):
    search_fields = ['name', 'account_2']
    
class CommentsAdmin(admin.ModelAdmin):
    search_fields = ['name']
    date_hierarchy = 'date'
    list_display = ('name','comment', 'date')

class LinkAbonentsAuthUserAdmin(admin.ModelAdmin):
    search_fields = ['name']
    #list_display = (u'name')
    
class TakenParamsAdmin(admin.ModelAdmin):
    search_fields = ['name']
    
class ObjectsAdmin(admin.ModelAdmin):
    search_fields = ['name']
    
class ParamsAdmin(admin.ModelAdmin):
    search_fields = ['name']
    
class LinkMetersTcpipSettingsAdmin(admin.ModelAdmin):
    search_fields = ['guid_meters__factory_number_manual', 'guid_meters__name']

    
class LinkMetersComportSettingsAdmin(admin.ModelAdmin):
    search_fields = ['guid_meters__factory_number_manual']
    
class LinkGroups80020MetersAdmin(admin.ModelAdmin):
    raw_id_fields = ('guid_meters', ) 

@admin.register(ReportConfig)
class ReportConfigAdmin(admin.ModelAdmin):
    list_display = [
        'number', 'is_active', 'name', 'guid_resources', 
        'separator', 'round_size', 'null_field',
        'show_lic_num'
    ]
    list_filter = ['guid_resources', 'is_active', 'separator']
    search_fields = ['number', 'name']   # ← поиск по номеру И имени
    list_editable = ['is_active']
    
    fieldsets = (
        ('Основное', {
            'fields': ('number', 'name', 'guid_resources', 'is_active')
        }),
        ('Форматирование', {
            'fields': (
                'separator', 'round_size', 
                'num_is_string', 'show_lic_num', 'null_field'
            )
        }),
        ('Отображение', {
            'fields': ('show_stoyak', 'show_floors', 'comment_to_excel')
        }),
        ('Сортировка', {
            'fields': ('order_fields', 'order_direction'),
            'classes': ('collapse',)
        }),
    )
    
    # Только для суперпользователя
    def has_add_permission(self, request):
        return request.user.is_superuser
    
    def has_change_permission(self, request, obj=None):
        return request.user.is_superuser
    
    def has_delete_permission(self, request, obj=None):
        return request.user.is_superuser



admin.site.register(Objects, ObjectsAdmin)
admin.site.register(Abonents, AbonentsAdmin)
admin.site.register(Comments, CommentsAdmin)
# admin.site.register(LinkAbonentsAuthUser, LinkAbonentsAuthUserAdmin)
admin.site.register(TypesAbonents)
admin.site.register(Meters, MetersAdmin)
#admin.site.register(MonthlyValues)
#admin.site.register(DailyValues)
#admin.site.register(CurrentValues)
#admin.site.register(VariousValues)
admin.site.register(TakenParams, TakenParamsAdmin)
#admin.site.register(Resources)
admin.site.register(TypesMeters)
#admin.site.register(Measurement)
#admin.site.register(NamesParams)
admin.site.register(Params, ParamsAdmin)
admin.site.register(TypesParams)
admin.site.register(BalanceGroups)
admin.site.register(LinkAbonentsTakenParams, LinkAbonentsTakenParamsAdmin)
admin.site.register(LinkMetersComportSettings, LinkMetersComportSettingsAdmin)
admin.site.register(LinkMetersTcpipSettings, LinkMetersTcpipSettingsAdmin)
admin.site.register(ComportSettings)
admin.site.register(TcpipSettings)
admin.site.register(LinkBalanceGroupsMeters)
admin.site.register(Groups80020)
admin.site.register(LinkGroups80020Meters, LinkGroups80020MetersAdmin)
