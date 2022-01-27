#include <efi.h>
#include <efilib.h>

EFI_STATUS
    EFIAPI
efi_main (EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE *SystemTable)
{
    EFI_INPUT_KEY Key;
    EFI_STATUS Status;

    InitializeLib(ImageHandle, SystemTable);

    Print(L"Hello, world, this is quite fun!!\n");

    uefi_call_wrapper(ST->ConOut->OutputString, 2, ST->ConOut, L"Hello World!\n");

    Status = uefi_call_wrapper(ST->ConIn->Reset, 2, ST->ConIn, FALSE);
    if (EFI_ERROR(Status))
        return Status;

    while ((Status = uefi_call_wrapper(ST->ConIn->ReadKeyStroke, 2, ST->ConIn, &Key)) == EFI_NOT_READY);

    return Status;
}
