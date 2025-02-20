from django.core.management.base import BaseCommand
from accounts.models import Roles

class Command(BaseCommand):
    help = "Ensure required roles exist"

    def handle(self, *args, **options):
        # Create admin role if it doesn't exist
        if not Roles.objects.filter(name="admin").exists():
            Roles.objects.create(name="admin")
            self.stdout.write(self.style.SUCCESS('Created admin role'))
        else:
            self.stdout.write('Admin role already exists')
