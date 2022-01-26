from dtcanonicalize import DTParser, Canonicalizer
import os.path as op
import os


def test_canonicalize():
    test_dir = op.abspath(op.dirname(__file__))
    test_file_dir = op.join('examples', 'original')
    # test_files = [f for f in os.listdir(test_file_dir) if f.endswith('.xml')]

    test_files = [entry.path for entry in os.scandir(
        test_file_dir) if entry.is_file()]

    c = Canonicalizer(DTParser(), test_files[1])
    c.canonicalize()
    with open(test_files[1].replace('.xml', '_out.xml'), 'w') as f:

        c.write_xml(f)

    assert False
