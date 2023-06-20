"""
WSGI config for app project.

It exposes the WSGI callable as a module-level variable named ``application``.

For more information on this file, see
https://docs.djangoproject.com/en/4.2/howto/deployment/wsgi/
"""

import os
import debugpy
import platform
import sys

from django.core.wsgi import get_wsgi_application


# We defer to a DJANGO_SETTINGS_MODULE already in the environment. This breaks
# if running multiple sites in the same mod_wsgi process. To fix this, use
# mod_wsgi daemon mode with each site in its own daemon process, or use
# os.environ["DJANGO_SETTINGS_MODULE"] = "archerdx.settings"
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "app.settings")

# This application object is used by any WSGI server configured to use this
# file. This includes Django's development server, if the WSGI_APPLICATION
# setting points here.
try:
    from django.core.wsgi import get_wsgi_application
    
    application = get_wsgi_application()
except Exception as e:
    import sys
    import traceback

    exc_type, exc_value, exc_traceback = sys.exc_info()
    html_formatted_lines = '<pre><code>%s</code></pre>' % '</code><br><code>'.join(traceback.format_exc().splitlines())

    def application(env, start_response):
        start_response('200 OK', [('Content-Type', 'text/html')])

        vars_snippets = ('</code><br><code>'.join(['{k}={v}'.format(k=k, v=v) for k, v in os.environ.items()]))
        environment_vars = '<pre><code>%s</code></pre>' % vars_snippets

        return [
            """
                <strong>Error loading wsgi application!</strong>
                <br><br>
                {traceback}
                <br><br>
                <strong>Environment Variables:</strong>
                <br><br>
                {environment}
            """.format(traceback=html_formatted_lines, environment=environment_vars).encode('utf-8')
        ]