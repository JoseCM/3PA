`ifndef __MEM_BUS_DEF__
`define __MEM_BUS_DEF__

`include "pipelinedefs.vh"

// ESTES NOMES (IN / OUT) SAO DA PERSPECTIVA DA CACHE

/******* DcacheInBus *************/

`define DBUSI_WIDTH        ( `MA_WIDTH + `RS2VAL_WIDTH + `ALURSLT_WIDTH)

`define DBUSI_MA_LSB       (0)
`define DBUSI_MA_MSB       (`MA_WIDTH - 1 + `DBUSI_MA_LSB)
`define DBUSI_MA           `DBUSI_MA_MSB : `DBUSI_MA_LSB

`define DBUSI_DATA_LSB       (`DBUSI_MA_MSB + 1)
`define DBUSI_DATA_MSB       (`RS2VAL_WIDTH - 1 + `DBUSI_DATA_LSB)
`define DBUSI_DATA           `DBUSI_DATA_MSB : `DBUSI_DATA_LSB

`define DBUSI_ADDR_LSB       (`DBUSI_DATA_MSB + 1)
`define DBUSI_ADDR_MSB       (`ALURSLT_WIDTH - 1 + `DBUSI_ADDR_LSB)
`define DBUSI_ADDR           `DBUSI_ADDR_MSB : `DBUSI_ADDR_LSB

/******* DcacheOutBus *************/

`define DBUSO_WIDTH          (`MEMOUT_WIDTH + `MISS_WIDTH)

`define MISS_WIDTH           (1)

`define DBUSO_DATA_LSB       (0)
`define DBUSO_DATA_MSB       (`MEMOUT_WIDTH - 1 + `DBUSO_DATA_LSB)
`define DBUSO_DATA           `DBUSO_DATA_MSB : `DBUSO_DATA_LSB

`define DBUSO_MISS      `DBUSO_DATA_MSB + 1


/******* IcacheInBus *************/

`define ADDR_WIDTH       (32)

`define IBUSI_ADDR_LSB       (0)
`define IBUSI_ADDR_MSB       (`ADDR_WIDTH - 1 + `IBUSI_ADDR_LSB)
`define IBUSI_ADDR           `IBUSI_ADDR_MSB : `IBUSI_ADDR_LSB

/******* IcacheOutBus *************/

`define IBUSO_WIDTH          (`MEMOUT_WIDTH + `MISS_WIDTH)

`define IBUSO_DATA_LSB       (0)
`define IBUSO_DATA_MSB       (`MEMOUT_WIDTH - 1 + `IBUSO_DATA_LSB)
`define IBUSO_DATA           `IBUSO_DATA_MSB : `IBUSO_DATA_LSB

`define IBUSO_MISS           `IBUSO_DATA_MSB + 1

`endif