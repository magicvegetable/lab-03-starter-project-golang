import subprocess
import signal
import os

try:
    subprocess.run(['./build/fizzbuzz', 'serve'])
except KeyboardInterrupt:
    os.killpg(os.getpgrp(), signal.SIGTERM)
except signal.SIGINT:
    os.killpg(os.getpgrp(), signal.SIGTERM)
except signal.SIGTERM:
    os.killpg(os.getpgrp(), signal.SIGTERM)

