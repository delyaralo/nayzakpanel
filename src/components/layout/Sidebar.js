import React from 'react';
import { useNavigate, useLocation } from 'react-router-dom';
import {
  Drawer,
  List,
  ListItem,
  ListItemIcon,
  ListItemText,
  Box,
  Typography,
  Divider,
} from '@mui/material';
import {
  Dashboard as DashboardIcon,
  Home as HomeIcon,
  AddHome as NewHomeIcon,
  Business as ComplexIcon,
  BusinessCenter as OfficeIcon,
} from '@mui/icons-material';
import styled from 'styled-components';

const drawerWidth = 240;

const StyledDrawer = styled(Drawer)`
  width: ${drawerWidth}px;
  flex-shrink: 0;
  & .MuiDrawer-paper {
    width: ${drawerWidth}px;
    box-sizing: border-box;
    background-color: #1a237e;
    color: white;
  }
`;

const LogoContainer = styled(Box)`
  padding: 20px;
  text-align: center;
  background-color: #0d1642;
`;

const menuItems = [
  { text: 'لوحة التحكم', icon: <DashboardIcon />, path: '/' },
  { text: 'العقارات', icon: <HomeIcon />, path: '/properties' },
  { text: 'العقارات الجديدة', icon: <NewHomeIcon />, path: '/new-properties' },
  { text: 'المجمعات', icon: <ComplexIcon />, path: '/complexes' },
  { text: 'المكاتب العقارية', icon: <OfficeIcon />, path: '/real-estate-offices' },
];

function Sidebar() {
  const navigate = useNavigate();
  const location = useLocation();

  return (
    <StyledDrawer variant="permanent">
      <LogoContainer>
        <Typography variant="h6" component="div" sx={{ fontWeight: 'bold' }}>
          لوحة تحكم نيزك العقارية
        </Typography>
      </LogoContainer>
      <Divider sx={{ backgroundColor: 'rgba(255,255,255,0.1)' }} />
      <List>
        {menuItems.map((item) => (
          <ListItem
            button
            key={item.text}
            onClick={() => navigate(item.path)}
            sx={{
              backgroundColor: location.pathname === item.path ? 'rgba(255,255,255,0.1)' : 'transparent',
              '&:hover': {
                backgroundColor: 'rgba(255,255,255,0.1)',
              },
            }}
          >
            <ListItemIcon sx={{ color: 'white', minWidth: 40 }}>
              {item.icon}
            </ListItemIcon>
            <ListItemText primary={item.text} />
          </ListItem>
        ))}
      </List>
    </StyledDrawer>
  );
}

export default Sidebar; 