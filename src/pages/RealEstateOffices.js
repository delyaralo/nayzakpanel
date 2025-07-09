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
  Rating,
} from '@mui/material';
import {
  Add as AddIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
  Phone as PhoneIcon,
  Email as EmailIcon,
  LocationOn as LocationIcon,
} from '@mui/icons-material';
import { DataGrid } from '@mui/x-data-grid';

const RealEstateOffices = () => {
  const [open, setOpen] = useState(false);
  const [selectedOffice, setSelectedOffice] = useState(null);

  // Sample data - replace with actual API data
  const offices = [
    {
      id: 1,
      name: 'مكتب نيزك العقاري',
      owner: 'أحمد محمد',
      phone: '0500000000',
      email: 'info@nayzak.com',
      address: 'الرياض، حي النخيل',
      licenseNumber: '123456',
      rating: 4.5,
      activeListings: 45,
      isVerified: true,
      workingHours: '9:00 ص - 5:00 م',
      services: ['بيع', 'شراء', 'إيجار', 'تقييم'],
    },
    // Add more sample data as needed
  ];

  const columns = [
    { field: 'id', headerName: 'ID', width: 70 },
    { field: 'name', headerName: 'اسم المكتب', width: 200 },
    { field: 'owner', headerName: 'المالك', width: 150 },
    { field: 'phone', headerName: 'رقم الهاتف', width: 130 },
    { field: 'email', headerName: 'البريد الإلكتروني', width: 200 },
    { field: 'address', headerName: 'العنوان', width: 200 },
    { field: 'licenseNumber', headerName: 'رقم الترخيص', width: 130 },
    {
      field: 'rating',
      headerName: 'التقييم',
      width: 130,
      renderCell: (params) => (
        <Rating value={params.value} readOnly precision={0.5} />
      ),
    },
    { field: 'activeListings', headerName: 'العقارات النشطة', width: 130 },
    {
      field: 'isVerified',
      headerName: 'موثق',
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
    setSelectedOffice(null);
    setOpen(true);
  };

  const handleEdit = (office) => {
    setSelectedOffice(office);
    setOpen(true);
  };

  const handleDelete = (id) => {
    // Implement delete functionality
    console.log('Delete office:', id);
  };

  const handleClose = () => {
    setOpen(false);
    setSelectedOffice(null);
  };

  const handleSave = () => {
    // Implement save functionality
    handleClose();
  };

  return (
    <Box sx={{ p: 3 }}>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 3 }}>
        <Typography variant="h4" sx={{ fontWeight: 'bold' }}>
          المكاتب العقارية
        </Typography>
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          onClick={handleAdd}
        >
          إضافة مكتب جديد
        </Button>
      </Box>

      <Paper sx={{ height: 600, width: '100%' }}>
        <DataGrid
          rows={offices}
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
          {selectedOffice ? 'تعديل مكتب عقاري' : 'إضافة مكتب عقاري جديد'}
        </DialogTitle>
        <DialogContent>
          <Grid container spacing={2} sx={{ mt: 1 }}>
            <Grid item xs={12} md={6}>
              <TextField
                label="اسم المكتب"
                fullWidth
                defaultValue={selectedOffice?.name}
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                label="المالك"
                fullWidth
                defaultValue={selectedOffice?.owner}
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                label="رقم الهاتف"
                fullWidth
                defaultValue={selectedOffice?.phone}
                InputProps={{
                  startAdornment: (
                    <PhoneIcon color="action" sx={{ mr: 1 }} />
                  ),
                }}
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                label="البريد الإلكتروني"
                type="email"
                fullWidth
                defaultValue={selectedOffice?.email}
                InputProps={{
                  startAdornment: (
                    <EmailIcon color="action" sx={{ mr: 1 }} />
                  ),
                }}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                label="العنوان"
                fullWidth
                defaultValue={selectedOffice?.address}
                InputProps={{
                  startAdornment: (
                    <LocationIcon color="action" sx={{ mr: 1 }} />
                  ),
                }}
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                label="رقم الترخيص"
                fullWidth
                defaultValue={selectedOffice?.licenseNumber}
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                label="ساعات العمل"
                fullWidth
                defaultValue={selectedOffice?.workingHours}
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                label="التقييم"
                type="number"
                fullWidth
                defaultValue={selectedOffice?.rating}
                InputProps={{
                  inputProps: { min: 0, max: 5, step: 0.5 }
                }}
              />
            </Grid>
            <Grid item xs={12} md={6}>
              <TextField
                label="العقارات النشطة"
                type="number"
                fullWidth
                defaultValue={selectedOffice?.activeListings}
              />
            </Grid>
            <Grid item xs={12}>
              <TextField
                label="الخدمات"
                fullWidth
                multiline
                rows={2}
                defaultValue={selectedOffice?.services?.join(', ')}
                helperText="اكتب الخدمات مفصولة بفواصل"
              />
            </Grid>
            <Grid item xs={12}>
              <FormControlLabel
                control={
                  <Switch
                    defaultChecked={selectedOffice?.isVerified}
                    color="primary"
                  />
                }
                label="مكتب موثق"
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

export default RealEstateOffices; 