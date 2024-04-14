#!/usr/bin/python3
"""
Fabric script (based on the file 2-do_deploy_web_static.py) that creates
and distributes an archive to your web servers, using the function deploy
"""

from 1-pack_web_static import do_pack
from 2-do_deploy_web_static import do_deploy


def deploy():
    """
    Full deployment
    """
    archive_path = do_pack()

    if not archive_path:
        return False

    status = do_deploy(archive_path)

    return status

