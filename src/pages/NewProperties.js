import React, { useState } from 'react';
import {
  Box,
  Typography,
  Button,
  Paper,
  IconButton,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  MenuItem,
  Grid,
  FormControlLabel,
  Switch,
} from '@mui/material';
import {
  Add as AddIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
} from '@mui/icons-material';
import { DataGrid } from '@mui/x-data-grid';

const NewProperties = () => {
  const [open, setOpen] = useState(false);
  const [selectedProperty, setSelectedProperty] = useState(null);

  // Sample data - replace with actual API data
  const newProperties = [
    {
      id: 1,
      title: 'شقة جديدة',
      type: 'شقة',
      area: 150,
      price: 750000,
      location: 'جدة',
      status: 'قيد الإنشاء',
      expectedCompletion: '2024-12-31',
      developer: 'شركة نيزك',
      features: ['مسبح', 'صالة رياضية', 'حديقة'],
      isFeatured: true,
    },
    // Add more sample data as needed
  ];

  const columns = [
    { field: 'id', headerName: 'ID', width: 70 },
    { field: 'title', headerName: 'عنوان العقار', width: 200 },
    { field: 'type', headerName: 'النوع', width: 130 },
    { field: 'area', headerName: 'المساحة (م²)', width: 130 },
    { field: 'price', headerName: 'السعر', width: 130 },
    { field: 'location', headerName: 'الموقع', width: 130 },
    { field: 'status', headerName: 'الحالة', width: 130 },
    { field: 'expectedCompletion', headerName: 'تاريخ الإنجاز', width: 130 },
    { field: 'developer', headerName: 'المطور', width: 130 },
    {
      field: 'isFeatured',
      headerName: 'مميز',
      width: 100,
      renderCell: (params) => (
        <Switch checked={params.value} disabled />
      ),
    },
    {
      field: 'actions',
      headerName: 'الإجراءات',
      width: 130,
      renderCell: (params) => (
        <Box>
          <IconButton
            color="primary"
            onClick={() => handleEdit(params.row)}
            size="small"
          >
            <EditIcon />
          </IconButton>
          <IconButton
            color="error"
            onClick={() => handleDelete(params.row.id)}
            size="small"
          >
            <DeleteIcon />
          </IconButton>
        </Box>
      ),
    },
  ];

  const handleAdd = () => {
    setSelectedProperty(null);
    setOpen(true);
  };

  const handleEdit = (property) => {
    setSelectedProperty(property);
    setOpen(true);
  };

  const handleDelete = (id) => {
    // Implement delete functionality
    console.log('Delete new property:', id);
  };

  const handleClose = () => {
    setOpen(false);
    setSelectedProperty(null);
  };

  const handleSave = () => {
    // Implement save functionality
    handleClose();
  };

  return (
    <Box sx={{ p: 3 }}>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 3 }}>
        <Typography variant="h4" sx={{ fontWeight: 'bold' }}>
          العقارات الجديدة
        </Typography>
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          onClick={handleAdd}
        >
          إضافة عقار جديد
        </Button>
      </Box>

      <Paper sx={{ height: 600, width: '100%' }}>
        <DataGrid
          rows={newProperties}
          columns={columns}
          pageSize={10}
          rowsPerPageOptions={[10]}
          checkboxSelection
          disableSelectionOnClick
          sx={{ direction: 'rtl' }}
        />
      </Paper>

      <Dialog open={open} onClose={handleClose} maxWidth="md" fullWidth>
        <DialogTitle>
          {selectedProperty ? 'تعديل عقار جديد' : 'إضافة عقار جديد'}
        </DialogTitle>
        <DialogContent>
          <Grid container spacing={2} sx={{ mt: 1 }}>
            <Grid item xs={12} md={6}>
              <TextField
                label="عنوان العقار"
                fullWidth
                defaultValue={selectedProperty?.title}
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                select
                label="نوع العقار"
                fullWidth
                defaultValue={selectedProperty?.type || ''}
              >
                <MenuItem value="شقة">شقة</MenuItem>
                <MenuItem value="فيلا">فيلا</MenuItem>
                <MenuItem value="محل">محل</MenuItem>
                <MenuItem value="مكتب">مكتب</MenuItem>
              </TextField>
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                label="المساحة (م²)"
                type="number"
                fullWidth
                defaultValue={selectedProperty?.area}
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                label="السعر"
                type="number"
                fullWidth
                defaultValue={selectedProperty?.price}
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                label="الموقع"
                fullWidth
                defaultValue={selectedProperty?.location}
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                select
                label="الحالة"
                fullWidth
                defaultValue={selectedProperty?.status || ''}
              >
                <MenuItem value="قيد الإنشاء">قيد الإنشاء</MenuItem>
                <MenuItem value="قريباً">قريباً</MenuItem>
                <MenuItem value="متاح للبيع">متاح للبيع</MenuItem>
              </TextField>
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                label="تاريخ الإنجاز المتوقع"
                type="date"
                fullWidth
                defaultValue={selectedProperty?.expectedCompletion}
                InputLabelProps={{ shrink: true }}
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                label="المطور"
                fullWidth
                defaultValue={selectedProperty?.developer}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                label="المميزات"
                fullWidth
                multiline
                rows={3}
                defaultValue={selectedProperty?.features?.join(', ')}
                helperText="اكتب المميزات مفصولة بفواصل"
              />
            </Grid>
            <Grid item xs={12}>
              <FormControlLabel
                control={
                  <Switch
                    defaultChecked={selectedProperty?.isFeatured}
                    color="primary"
                  />
                }
                label="عقار مميز"
              />
            </Grid>
          </Grid>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleClose}>إلغاء</Button>
          <Button onClick={handleSave} variant="contained">
            حفظ
          </Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
};

export default NewProperties; 