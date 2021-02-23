from psana import DataSource
ds = DataSource(exp='tmoc00118', run=222, dir='/cds/data/psdm/prj/public01/xtc', max_events=10)
myrun = next(ds.runs())
opal = myrun.Detector('tmoopal')
epics_det = myrun.Detector('IM2K4_XrayPower')
for evt in myrun.events():
    img = opal.raw.image(evt)
    epics_val = epics_det(evt)
    # check for missing data
    if img is None or epics_val is None:
        print('none')
        continue
    print(img.shape,epics_val)
