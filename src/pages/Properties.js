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
} from '@mui/material';
import {
  Add as AddIcon,
  Edit as EditIcon,
  Delete as DeleteIcon,
} from '@mui/icons-material';
import { DataGrid } from '@mui/x-data-grid';

const Properties = () => {
  const [open, setOpen] = useState(false);
  const [selectedProperty, setSelectedProperty] = useState(null);

  // Sample data - replace with actual API data
  const properties = [
    {
      id: 1,
      title: 'شقة فاخرة',
      type: 'شقة',
      area: 120,
      price: 500000,
      location: 'الرياض',
      status: 'متاح',
      owner: 'أحمد محمد',
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
    { field: 'owner', headerName: 'المالك', width: 130 },
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
    console.log('Delete property:', id);
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
          العقارات
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
          rows={properties}
          columns={columns}
          pageSize={10}
          rowsPerPageOptions={[10]}
          checkboxSelection
          disableSelectionOnClick
          sx={{ direction: 'rtl' }}
        />
      </Paper>

      <Dialog open={open} onClose={handleClose} maxWidth="sm" fullWidth>
        <DialogTitle>
          {selectedProperty ? 'تعديل عقار' : 'إضافة عقار جديد'}
        </DialogTitle>
        <DialogContent>
          <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2, mt: 2 }}>
            <TextField
              label="عنوان العقار"
              fullWidth
              defaultValue={selectedProperty?.title}
            />
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
            <TextField
              label="المساحة (م²)"
              type="number"
              fullWidth
              defaultValue={selectedProperty?.area}
            />
            <TextField
              label="السعر"
              type="number"
              fullWidth
              defaultValue={selectedProperty?.price}
            />
            <TextField
              label="الموقع"
              fullWidth
              defaultValue={selectedProperty?.location}
            />
            <TextField
              select
              label="الحالة"
              fullWidth
              defaultValue={selectedProperty?.status || ''}
            >
              <MenuItem value="متاح">متاح</MenuItem>
              <MenuItem value="محجوز">محجوز</MenuItem>
              <MenuItem value="مباع">مباع</MenuItem>
            </TextField>
            <TextField
              label="المالك"
              fullWidth
              defaultValue={selectedProperty?.owner}
            />
          </Box>
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

export default Properties; 