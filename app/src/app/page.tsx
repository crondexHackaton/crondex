import React from 'react';
import { Box, Card, CardContent, Typography, Button, FormControl, InputLabel, OutlinedInput, InputAdornment } from '@mui/material';
import LockIcon from '@mui/icons-material/Lock';
import { ConnectButton } from '@rainbow-me/rainbowkit';

export function Page() {
  return (
    <>  <Box sx={{ position: 'absolute', top: '10px', right: '10px' }}>
      <ConnectButton />
    </Box>
      <Typography variant="h1" margin-top="60px" component="div" align="center" fontWeight="bold" sx={{ mt: 8 }}>
        Crondex
      </Typography >
      <Box
        sx={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          paddingTop: '60px'
        }}
      >
        <Card>
          <CardContent>

            <Box
              sx={{
                display: 'flex',
                justifyContent: 'center',
                flexDirection: 'column',
                mt: 2,
                gap: 4,
              }}
            >
              <Box>
                <Typography variant="h3" fontWeight="bold">Cross Chain Vault</Typography>
              </Box>
              <Box>
                <Typography variant="body1" fontWeight="bold">The best cross chain yeilds in DeFi with a single click</Typography>
              </Box>
              <Box>
                <Typography variant="body1" fontWeight="bold">TVL: $50k</Typography>
              </Box>
              <Box>
                <Typography variant="body1" fontWeight="bold">Yield: 12%</Typography>
              </Box>
              <Box>
                <Typography variant="body1" fontWeight="bold">Deposit Cap: 50k</Typography>
              </Box>
              <FormControl fullWidth sx={{ m: 1 }}>
                <InputLabel htmlFor="outlined-adornment-amount">Amount</InputLabel>
                <OutlinedInput
                  id="outlined-adornment-amount"
                  startAdornment={<InputAdornment position="start">$</InputAdornment>}
                  label="Amount"
                />
              </FormControl>

              <Box
                sx={{
                  display: 'flex',
                  justifyContent: 'center',
                  alignItems: 'center',
                  mt: 4,
                  gap: 1,
                }}
              >
                <Button variant="contained">Approve</Button>
                <Button variant="contained">Deposit</Button>
              </Box>
            </Box>
          </CardContent>
        </Card>
      </Box ></>
  );
}

export default Page;
