// Copyright Cartesi and individual authors (see AUTHORS)
// SPDX-License-Identifier: LGPL-3.0-or-later
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Lesser General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option) any
// later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
// PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License along
// with this program (see COPYING). If not, see <https://www.gnu.org/licenses/>.
//

#ifndef DTB_H
#define DTB_H

/// \file
/// \brief Device Tree Blob

#include <cstdint>

#include "machine-config.h"

namespace cartesi {

// Forward declarations
struct machine_config;

/// \brief Initializes flattened device tree from machine config on DTB
/// \param c Machine configuration.
/// \param dtb_start Pointer to start of DTB contiguous range in host memory
/// \param dtb_length Maximum amount of DTB to use from start.
void dtb_init(const machine_config &c, unsigned char *dtb_start, uint64_t dtb_length);

} // namespace cartesi

#endif
