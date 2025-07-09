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

const Complexes = () => {
  const [open, setOpen] = useState(false);
  const [selectedComplex, setSelectedComplex] = useState(null);

  // Sample data - replace with actual API data
  const complexes = [
    {
      id: 1,
      name: 'مجمع نيزك السكني',
      type: 'سكني',
      totalUnits: 100,
      availableUnits: 45,
      location: 'الرياض',
      status: 'قيد الإنشاء',
      expectedCompletion: '2024-12-31',
      developer: 'شركة نيزك',
      amenities: ['مسبح', 'صالة رياضية', 'حديقة', 'مسجد'],
      hasSecurity: true,
      hasParking: true,
    },
    // Add more sample data as needed
  ];

  const columns = [
    { field: 'id', headerName: 'ID', width: 70 },
    { field: 'name', headerName: 'اسم المجمع', width: 200 },
    { field: 'type', headerName: 'النوع', width: 130 },
    { field: 'totalUnits', headerName: 'إجمالي الوحدات', width: 130 },
    { field: 'availableUnits', headerName: 'الوحدات المتاحة', width: 130 },
    { field: 'location', headerName: 'الموقع', width: 130 },
    { field: 'status', headerName: 'الحالة', width: 130 },
    { field: 'expectedCompletion', headerName: 'تاريخ الإنجاز', width: 130 },
    { field: 'developer', headerName: 'المطور', width: 130 },
    {
      field: 'hasSecurity',
      headerName: 'حراسة',
      width: 100,
      renderCell: (params) => (
        <Switch checked={params.value} disabled />
      ),
    },
    {
      field: 'hasParking',
      headerName: 'موقف سيارات',
      width: 130,
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
    setSelectedComplex(null);
    setOpen(true);
  };

  const handleEdit = (complex) => {
    setSelectedComplex(complex);
    setOpen(true);
  };

  const handleDelete = (id) => {
    // Implement delete functionality
    console.log('Delete complex:', id);
  };

  const handleClose = () => {
    setOpen(false);
    setSelectedComplex(null);
  };

  const handleSave = () => {
    // Implement save functionality
    handleClose();
  };

  return (
    <Box sx={{ p: 3 }}>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 3 }}>
        <Typography variant="h4" sx={{ fontWeight: 'bold' }}>
          المجمعات
        </Typography>
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          onClick={handleAdd}
        >
          إضافة مجمع جديد
        </Button>
      </Box>

      <Paper sx={{ height: 600, width: '100%' }}>
        <DataGrid
          rows={complexes}
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
          {selectedComplex ? 'تعديل مجمع' : 'إضافة مجمع جديد'}
        </DialogTitle>
        <DialogContent>
          <Grid container spacing={2} sx={{ mt: 1 }}>
            <Grid item xs={12} md={6}>
              <TextField
                label="اسم المجمع"
                fullWidth
                defaultValue={selectedComplex?.name}
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                select
                label="نوع المجمع"
                fullWidth
                defaultValue={selectedComplex?.type || ''}
              >
                <MenuItem value="سكني">سكني</MenuItem>
                <MenuItem value="تجاري">تجاري</MenuItem>
                <MenuItem value="مختلط">مختلط</MenuItem>
              </TextField>
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                label="إجمالي الوحدات"
                type="number"
                fullWidth
                defaultValue={selectedComplex?.totalUnits}
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                label="الوحدات المتاحة"
                type="number"
                fullWidth
                defaultValue={selectedComplex?.availableUnits}
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                label="الموقع"
                fullWidth
                defaultValue={selectedComplex?.location}
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                select
                label="الحالة"
                fullWidth
                defaultValue={selectedComplex?.status || ''}
              >
                <MenuItem value="قيد الإنشاء">قيد الإنشاء</MenuItem>
                <MenuItem value="قريباً">قريباً</MenuItem>
                <MenuItem value="متاح للبيع">متاح للبيع</MenuItem>
                <MenuItem value="مكتمل">مكتمل</MenuItem>
              </TextField>
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                label="تاريخ الإنجاز المتوقع"
                type="date"
                fullWidth
                defaultValue={selectedComplex?.expectedCompletion}
                InputLabelProps={{ shrink: true }}
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                label="المطور"
                fullWidth
                defaultValue={selectedComplex?.developer}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                label="المرافق"
                fullWidth
                multiline
                rows={3}
                defaultValue={selectedComplex?.amenities?.join(', ')}
                helperText="اكتب المرافق مفصولة بفواصل"
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <FormControlLabel
                control={
                  <Switch
                    defaultChecked={selectedComplex?.hasSecurity}
                    color="primary"
                  />
                }
                label="حراسة 24 ساعة"
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <FormControlLabel
                control={
                  <Switch
                    defaultChecked={selectedComplex?.hasParking}
                    color="primary"
                  />
                }
                label="موقف سيارات"
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

export default Complexes; 