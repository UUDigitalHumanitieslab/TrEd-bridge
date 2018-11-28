import lxml.etree as ET


def process_input(input_path):
    tree = ET.parse(input_path)
    root = tree.getroot()
    metadata = root.find('metadata')
    origutt = root.find('.//meta[@name="origutt"]')
    origutt_old = '<meta type="text" name="origutt_old" value="{}"/>\n'.format(
        origutt.get('value'))
    metadata.insert(
        metadata.index(origutt)+1, ET.XML(origutt_old))
    new_metadata = ET.tostring(metadata) + b'\n'

    return origutt.get('value'), new_metadata
