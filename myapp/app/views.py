from django.http import HttpResponse
import platform
import debugpy
import sys

def homePageView(request):
    debugpy.log_to('/tmp/logs')
    debugpy.configure(python='/tmp/Python-3.8.10/python')
    debugpy.listen(("localhost", 5678))
    debugpy.wait_for_client()
    return HttpResponse(f"""
        OS version: {platform.platform()}<br/>
        Debugpy Version: {debugpy.__version__}<br/>
        File path: {__file__}<br/>
        Python version: {sys.version}
    """)