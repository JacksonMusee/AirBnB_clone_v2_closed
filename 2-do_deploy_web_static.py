#!/usr/bin/python3
"""
Fabric script (based on the file 1-pack_web_static.py) that distributes
an archive to your web servers, using the function do_deploy
"""

from fabric.operations import run, put
from os.path import exists


env.hosts = [193236-web-01, 193236-web-02]
env.key_filename = '~/.ssh/school'
env.user = 'ubuntu'

def do_deploy(archive_path):
    """
    Task/function to upload an acrchivr, extract and deploy new version
    of web_static
    """
    try:
        if not exists(archive_path):
            return False

        put(archive_path "/tmp/")

        archive_name = archive_path.split("/")[-1]
        rm_extension = archive_name.split(".")[0]

        remote_archive_path = "/tmp/" + archive_name

        run(f"mkdir -p /data/web_static/releases/{rm_extension}")
        run(f"tar -xzf {remote_archive_path} -C /data/web_static/releases/{rm_extension}")
        run(f"rm {remote_archive_path}")

        run("rm /data/web_static/current")
        run(f"ln -s /data/web_static/releases/{rm_extension} /data/web_static/current")

        return True

    except Exception as e:
        return False
