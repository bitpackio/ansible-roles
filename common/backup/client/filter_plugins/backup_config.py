#!/usr/bin/env python

class FilterModule(object):
    def filters(self):
        return {
            'parse_backup_destination': self.parse_backup_destination
        }

    def parse_backup_destination(self, backup_destination):
        """
        Parse restic backup destination.

        Args:
            backup_destination (str): Bbackup destination.
        Returns:
            dict: Parsed backup destination.
        """
        backup_config = {}
        backup_config['protocol'] = None
        backup_config['connection_string'] = None
        backup_config['path'] = None
        supported_protocols = ('sftp', 'local')

        if ':' in backup_destination:
            dest_parts = backup_destination.split(':')
            backup_config['protocol'] = dest_parts[0]
            backup_config['connection_string'] = "".join(dest_parts[1:-1])
            backup_config['path'] = dest_parts[-1]
        else:
            backup_config['protocol'] = 'local'
            backup_config['connection_string'] = None
            backup_config['path'] = backup_destination
        if backup_config['protocol'] not in supported_protocols:
            raise ValueError("Unsupported backup destination")

        return backup_config
