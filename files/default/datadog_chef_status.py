# chef.status
#  0: success
#  1: failure
# -1: plugin error

# chef.enabled
#  0: disabled
#  1: enabled

from checks import AgentCheck

class ChefStatus(AgentCheck):
    def check(self, instance):
        status_file = self.init_config.get('status_file', None)
        if status_file:
            try:
                f = open(status_file, 'r')
                if f.read().find('ok') == 0:
                    val = 0
                else:
                    val = 1
            except:
                val = -1
            else:
                f.close()
            self.gauge('chef.status', val)

        disabled_file = self.init_config.get('disabled_file', None)
        if disabled_file:
            if os.path.exists(disabled_file):
                val = 0
            else:
                val = 1
            self.gauge('chef.enabled', val)
