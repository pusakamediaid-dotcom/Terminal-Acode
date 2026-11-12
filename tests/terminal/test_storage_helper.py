"""Host-side smoke tests; Android permissions still require device testing."""
import pathlib
import subprocess
import tempfile
import unittest

SCRIPT = pathlib.Path(__file__).resolve().parents[2] / 'src/plugins/terminal/scripts/acode-storage.sh'

class StorageHelperTests(unittest.TestCase):
    def run_helper(self, *args):
        return subprocess.run(['sh', str(SCRIPT), *args], capture_output=True, text=True)

    def test_help(self):
        result = self.run_helper('help')
        self.assertEqual(result.returncode, 0)
        self.assertIn('PRoot root is not Android root', result.stdout)

    def test_directory_with_spaces_is_not_modified(self):
        with tempfile.TemporaryDirectory(prefix='storage test ') as directory:
            marker = pathlib.Path(directory) / 'keep.txt'
            marker.write_text('unchanged')
            result = self.run_helper('check', directory)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertIn('Directory listing: accessible', result.stdout)
            self.assertEqual(list(pathlib.Path(directory).iterdir()), [marker])
            self.assertEqual(marker.read_text(), 'unchanged')

    def test_missing_directory(self):
        with tempfile.TemporaryDirectory() as directory:
            self.assertEqual(self.run_helper('check', directory + '/missing').returncode, 1)

    def test_saf_uri(self):
        result = self.run_helper('check', 'content://example/tree/storage')
        self.assertEqual(result.returncode, 1)
        self.assertIn('not a filesystem path', result.stdout)

    def test_invalid_arguments(self):
        for args in [('check',), ('unknown',), ('status', 'extra'), ('check', '')]:
            self.assertEqual(self.run_helper(*args).returncode, 2)

if __name__ == '__main__':
    unittest.main()
