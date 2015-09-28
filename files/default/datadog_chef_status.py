# this check will read the status file and emit chef.status metric
#  0: success
#  1: failure
# -1: plugin error

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
            finally:
                f.close()
        else:
            val = -1
        self.gauge('chef.status', val)
