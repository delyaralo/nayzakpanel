import React from 'react';
import {
  Grid,
  Paper,
  Typography,
  Box,
  Card,
  CardContent,
} from '@mui/material';
import {
  Home as HomeIcon,
  AddHome as NewHomeIcon,
  Business as ComplexIcon,
  BusinessCenter as OfficeIcon,
} from '@mui/icons-material';
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
  PieChart,
  Pie,
  Cell,
} from 'recharts';

const StatCard = ({ title, value, icon, color }) => (
  <Card sx={{ height: '100%' }}>
    <CardContent>
      <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
        <Box
          sx={{
            backgroundColor: `${color}15`,
            borderRadius: '50%',
            p: 1,
            mr: 2,
          }}
        >
          {React.cloneElement(icon, { sx: { color: color } })}
        </Box>
        <Typography variant="h6" component="div">
          {title}
        </Typography>
      </Box>
      <Typography variant="h4" component="div" sx={{ fontWeight: 'bold' }}>
        {value}
      </Typography>
    </CardContent>
  </Card>
);

const Dashboard = () => {
  const stats = [
    {
      title: 'إجمالي العقارات',
      value: '1,234',
      icon: <HomeIcon />,
      color: '#1976d2',
    },
    {
      title: 'العقارات الجديدة',
      value: '56',
      icon: <NewHomeIcon />,
      color: '#2e7d32',
    },
    {
      title: 'المجمعات',
      value: '89',
      icon: <ComplexIcon />,
      color: '#ed6c02',
    },
    {
      title: 'المكاتب العقارية',
      value: '45',
      icon: <OfficeIcon />,
      color: '#9c27b0',
    },
  ];

  const monthlyData = [
    { name: 'يناير', عقارات: 65, مجمعات: 12 },
    { name: 'فبراير', عقارات: 59, مجمعات: 15 },
    { name: 'مارس', عقارات: 80, مجمعات: 20 },
    { name: 'أبريل', عقارات: 81, مجمعات: 18 },
    { name: 'مايو', عقارات: 56, مجمعات: 14 },
    { name: 'يونيو', عقارات: 55, مجمعات: 16 },
  ];

  const propertyTypes = [
    { name: 'شقق', value: 400 },
    { name: 'فلل', value: 300 },
    { name: 'محلات', value: 200 },
    { name: 'مكاتب', value: 100 },
  ];

  const COLORS = ['#0088FE', '#00C49F', '#FFBB28', '#FF8042'];

  return (
    <Box sx={{ p: 3 }}>
      <Typography variant="h4" sx={{ mb: 4, fontWeight: 'bold' }}>
        لوحة التحكم
      </Typography>

      <Grid container spacing={3}>
        {stats.map((stat) => (
          <Grid item xs={12} sm={6} md={3} key={stat.title}>
            <StatCard {...stat} />
          </Grid>
        ))}

        <Grid item xs={12} md={8}>
          <Paper sx={{ p: 3, height: '400px' }}>
            <Typography variant="h6" sx={{ mb: 3 }}>
              إحصائيات العقارات والمجمعات
            </Typography>
            <ResponsiveContainer width="100%" height="100%">
              <BarChart data={monthlyData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="name" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Bar dataKey="عقارات" fill="#1976d2" />
                <Bar dataKey="مجمعات" fill="#ed6c02" />
              </BarChart>
            </ResponsiveContainer>
          </Paper>
        </Grid>

        <Grid item xs={12} md={4}>
          <Paper sx={{ p: 3, height: '400px' }}>
            <Typography variant="h6" sx={{ mb: 3 }}>
              أنواع العقارات
            </Typography>
            <ResponsiveContainer width="100%" height="100%">
              <PieChart>
                <Pie
                  data={propertyTypes}
                  cx="50%"
                  cy="50%"
                  labelLine={false}
                  label={({ name, percent }) => `${name} ${(percent * 100).toFixed(0)}%`}
                  outerRadius={80}
                  fill="#8884d8"
                  dataKey="value"
                >
                  {propertyTypes.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                  ))}
                </Pie>
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          </Paper>
        </Grid>
      </Grid>
    </Box>
  );
};

export default Dashboard; 