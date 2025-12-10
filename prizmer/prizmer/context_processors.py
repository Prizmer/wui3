from django.conf import settings

def ridan_flag(request):
    """
    Adds the IS_RIDAN setting to the template context.
    """
    return {'IS_RIDAN': getattr(settings, 'IS_RIDAN', False)}
